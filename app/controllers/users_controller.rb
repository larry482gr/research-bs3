class UsersController < ApplicationController
  require 'digest/sha1'
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    if @current_user.nil? or not @current_user.can_access?('user_list')
      flash[:alert] = :no_access
      redirect_to :root and return
    else
      if @current_user.owner?
        @users = User.all.order('profile_id, username')
      else
        @users = User.order('profile_id, username').where('profile_id >= ?', 2)
        # @users = User.find(:all, :conditions => ['profile_id >= ?', 2], :order => 'profile_id, username')
      end
    end
  end

  def check_login
    pass = Digest::SHA1.hexdigest(params[:user][:password])
    @user = User.find_by_username(params[:user][:username])
    # @user_info = @user.user_info
    if @user and pass == @user.password and not @user.user_info.deleted?
      if not @user.user_info.activated?
        respond_to do |format|
          format.js {}
          format.json { render json: "{ \"id\": \"0\" }" }
        end
      elsif @user.user_info.blacklisted?
        respond_to do |format|
          format.js {}
          format.json { render json: "{ \"id\": \"-1\" }" }
        end
      else
        session[:id] = @user.password
        respond_to do |format|
          format.js {}
          format.json { render json: "{ \"id\": \"#{@user.id}\" }" }
        end
      end
    else
      respond_to do |format|
        format.js {}
        format.json { render json: "{ \"id\": \"-2\" }" }
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
        session[:id] = @user.password
        notices = ["Welcome to ResearchGr #{@user.username}!", 'You can start immediately by creating a new project']
        redirect_to(projects_path, :notice => notices.join('<br/>').html_safe) and return
      end
    end
    flash[:alert] = :activation_error_html
  end

  def logout
    session.delete(:id)
    redirect_to :root
  end

  # GET /users/1
  # GET /users/1.json
  def show
    session[:return_to] = '/'
    session[:return_to] = request.referer unless request.original_fullpath.to_s.in?(request.referer.to_s)
    if @current_user.nil? or (@current_user.id.to_i != params[:id].to_i and not @current_user.can_access?('user_show'))
      flash[:alert] = "Sorry! You don't have access to this page."
      redirect_to :root and return
    end
    @user = User.find(params[:id])
    if @current_user.profile.id.to_i > @user.profile.id.to_i and @current_user.id.to_i != @user.id.to_i
      flash[:alert] = 'Sorry! You cannot view info of a user who has higher profile than you.'
      redirect_to :root and return
    end
    begin
      @language = t(Language.find(@user.user_info.language_id).language)
    rescue ActiveRecord::RecordNotFound
      @language = Language.find(1).language
    end
  end

  # GET /users/new
  def new
    @user = User.new
    session[:return_to] = request.referer unless session[:return_to] != nil
    respond_to do |format|
      format.html { render action: 'new' }
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    session[:return_to] = '/'
    session[:return_to] = request.referer unless request.original_fullpath.to_s.in?(request.referer.to_s)
    if @current_user.nil? or (@current_user.id.to_i != params[:id].to_i and not @current_user.can_access?('user_edit'))
      flash[:alert] = "Sorry! You don't have access to this page."
      redirect_to :root and return
    end
    @user = User.find(params[:id])
    if @current_user.profile.id.to_i > @user.profile.id.to_i and @current_user.id.to_i != @user.id.to_i
      flash[:alert] = 'Sorry! You cannot edit a user who has the same or higher role than you.'
      redirect_to :root and return
    end
  end

  # POST /users
  # POST /users.json
  def create
    if request.referer.nil? or (@current_user != nil and not @current_user.can_access?('user_create'))
      flash[:alert] = "Sorry! You don't have access to this page."
      redirect_to :root and return
    end

    begin
      @user = User.create!(user_params)
    rescue ActiveRecord::RecordInvalid => validation_error
      warnings_array = validation_error.message[19..-1].split(', ')
      warning_list = '<ul>'
      warnings_array.each do |warning|
        warning_list += '<li>' + warning + '</li>'
      end
      warning_list += '</ul>'
      warning_message = 'Registration failed because:<br/>'
      flash[:alert] = (warning_message + warning_list).html_safe

      @user = User.new
      redirect_to :root and return
    end
    if @current_user == nil or @current_user.can_access?('user_create')
      @user_info = UserInfo.create(:user_id => @user.id)
      UserMailer.welcome_email(@user, @user_info.token, request.base_url).deliver
    end
    notices = ["Welcome to ResearchGr #{params[:user][:username]}!"]
    redirect_to(root_url, :notice => notices.join("<br/>").html_safe)
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @current_user.nil? or (@current_user.id.to_i != params[:id].to_i and not @current_user.can_access?('user_edit'))
      flash[:alert] = "Sorry! You don't have access to this page."
      redirect_to :root and return
    end
    @user = User.find(params[:id])
    if @current_user.profile.id.to_i > @user.profile.id.to_i and @current_user.id.to_i != @user.id.to_i
      flash[:alert] = 'Sorry! You cannot edit a user who has the same or higher role than you.'
      redirect_to :root and return
    end
    respond_to do |format|
      if @user.update(user_params) and @user.user_info.update(user_params[:user_info_attributes])
        if @current_user.can_access?('user_edit')
          if (admin_params[:profile_id].to_i != @user.profile_id.to_i)
            @user.history_user_infos.create({user_email: @user.email, admin: @current_user.id, from_value: @user.profile_id, to_value: admin_params[:profile_id], change_type: 'profile'})
          end
          @user.update(admin_params)
        end
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def change_profile

  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @current_user.nil? or (@current_user.id.to_i != params[:id].to_i and not @current_user.can_access?('user_delete'))
      flash[:alert] = "Sorry! You don't have access to this page."
      redirect_to :root and return
    end
    @user = User.find(params[:id])
    if @current_user.profile.id.to_i > @user.profile.id.to_i and @current_user.id.to_i != @user.id.to_i
      flash[:alert] = 'Sorry! You cannot delete a user who has the same or higher role than you.'
      redirect_to :root and return
    end

    @user.user_info.deleted = 1
    if @user.user_info.save!
      if @current_user.can_access?('user_delete')
        @user.history_user_infos.create({user_email: @user.email, admin: @current_user.id, from_value: 0, to_value: 1, change_type: 'deletion', comment: params[:comment]})

        respond_to do |format|
          format.js {}
          format.json { render json: "{ \"deleted\": \"1\" }" }
        end
      else
        respond_to do |format|
          format.html { redirect_to :root }
          format.json { head :no_content }
        end
      end
    else
      if @current_user.can_access?('user_delete')
        respond_to do |format|
          format.js {}
          format.json { render json: "{ \"deleted\": \"0\" }" }
        end
      else
        flash[:alert] = 'An error occured while trying to delete your account'
        respond_to do |format|
          format.html { redirect_to :root }
          format.json { head :no_content }
        end
      end
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
      params.require(:user).permit(:username, :password, :email, user_info_attributes: [:id, :first_name, :last_name, :language_id, :deleted])
    end

    def admin_params
      params.require(:user).permit(:profile_id, user_info_attributes: [:id, :activated, :blacklisted])
    end
end