class UsersController < ApplicationController
  require 'digest/sha1'
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    if session[:user].nil? or session[:user][:profile] == 3
      flash[:alert] = :no_access
      redirect_to :root and return
    else
      if session[:user][:profile] == 1
        @users = User.all
      else
        @users = User.order('profile_id, username').where(:profile_id => '>= 2')
        # @users = User.find(:all, :conditions => ['profile_id >= ?', 2], :order => 'profile_id, username')
      end
    end
  end

  def check_login
    pass = Digest::SHA1.hexdigest(params[:user][:password])
    @user = User.find_by_username(params[:user][:username])
    @user_info = @user.user_info
    if @user and pass == @user.password
      if @user_info.activated
        session[:user] = {id: @user.id, username: @user.username, profile: @user.profile.id}
        respond_to do |format|
          format.js {}
          format.json { render json: "{ \"id\": \"#{@user.id}\" }" }
        end
      else
        respond_to do |format|
          format.js {}
          format.json { render json: "{ \"id\": \"0\" }" }
        end
      end
    else
      respond_to do |format|
        format.js {}
        format.json { render json: "{ \"id\": \"-1\" }" }
      end
    end
  end

  def activate
    @user = User.find_by_username(params[:user])
    if @user
      @user_info = @user.user_info
      if @user_info.token == params[:token]
        @user_info.activated = 1
        @user_info.token = nil
        @user_info.save
        session[:user] = {:id => @user.id, :username => @user.username, :profile => @user.profile.id}
        notices = ["Welcome to ResearchGr #{@user.username}!", 'You can start immediately by creating a new project']
        redirect_to(projects_path, :notice => notices.join('<br/>').html_safe) and return
      end
    end
    flash[:alert] = :activation_error_html
  end

  def logout
    session.delete(:user)
    redirect_to :root
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if session[:user].nil? or (session[:user][:profile].to_i > 2 and session[:user][:id].to_i != params[:id].to_i)
      flash[:alert] = "Sorry! You don't have access to this page."
      redirect_to :root and return
    end
    @user = User.find(params[:id])
    profile = session[:user][:profile].to_i
    if profile > @user.profile.id.to_i # and session[:user][:id] != @user.id
      flash[:alert] = 'Sorry! You cannot view info of a user who has higher profile than you.'
      redirect_to :root and return
    end
    @user.user_info.language = @user.user_info.get_proper_language
  end

  # GET /users/new
  def new
    @user = User.new
    session[:return_to] = request.referer unless session[:return_to] != nil
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    if request.referer.nil? or (session[:user][:profile].to_i > 2 and session[:user][:id].to_i != params[:id].to_i)
      flash[:alert] = "Sorry! You don't have access to this page."
      redirect_to :root and return
    end
    @user = User.find(params[:id])
    if session[:user][:profile].to_i > @user.profile.id.to_i and session[:user][:id].to_i != @user.id.to_i
      flash[:alert] = 'Sorry! You cannot edit a user who has the same or higher role than you.'
      redirect_to :root and return
    end
  end

  # POST /users
  # POST /users.json
  def create
    begin
      @user = User.create!(user_params)
    rescue ActiveRecord::RecordInvalid => validation_error
      warnings_array = validation_error.message[19..-1].split(", ")
      warning_list = "<ul>"
      warnings_array.each do |warning|
        warning_list += "<li>" + warning + "</li>"
      end
      warning_list += "</ul>"
      warning_message = "Registration failed because:<br/>"
      flash[:alert] = (warning_message + warning_list).html_safe

      session[:username] = params[:user][:username]
      # session[:password] = params[:user][:password]
      session[:email] = params[:user][:email]
      @user = User.new
      redirect_to :root and return
    end
    if session[:user] == nil
      #user = User.find(:all, :conditions => ['username = ?', params[:user][:username]])
      @user_info = UserInfo.create(:user_id => @user.id)
      #@user_info = UserInfo.create(:user_id => @user.id)
      UserMailer.welcome_email(@user, @user_info.token, request.base_url).deliver
      # session[:user] = {:id => @user.id, :username => @user.username, :profile => @user.profile.id}
    end
    notices = ["Welcome to ResearchGr #{params[:user][:username]}!"]
    # flash[:notice] = notices.join("<br/>").html_safe
    redirect_to(root_url, :notice => notices.join("<br/>").html_safe)
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if !params[:old_pass][:password].empty? or !params[:new_pass][:password].empty?
      if params[:old_pass][:password].empty? or Digest::SHA1.hexdigest(params[:old_pass][:password]) != @user.password
        flash[:alert] = "Old password doesn't match your current password!"
        redirect_to edit_user_path(@user) and return
      elsif params[:new_pass][:password].empty?
        flash[:alert] = "You should fill a new password!"
        redirect_to edit_user_path(@user) and return
      else
        params[:user][:password] = Digest::SHA1.hexdigest(params[:new_pass][:password])
      end
    end
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def change_role

  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if request.referer.nil? or request.referer.index(Rails.root.to_s) != 0
      flash[:alert] = 'You think you are a hacker???'
      redirect_to :root and return
    end
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  def search
    @user = User.find_by(username: params[:search_terms[:username]], email: params[:search_terms[:email]])
    redirect_to user_path(@user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :email)
    end
end
