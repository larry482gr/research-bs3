class UsersController < ApplicationController
  require 'digest/sha1'
  before_action :set_referer, only: [:show, :edit, :new]
  #force_ssl except: :autocomplete

  # GET /users
  # GET /users.json
  def index
    if @current_user.nil? or not @current_user.can_access?('user_list')
      flash[:alert] = (t :no_access)
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
        session[:email] = @user.email
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
        @user_info.activated = true
        @user_info.token = nil
        @user_info.save
        session[:id] = @user.password
        session[:email] = @user.email
        notices = ["#{t :welcome} #{@user.username}!", (t :start_immediately)]
        redirect_to(projects_path, :notice => notices.join('<br/>')) and return
      end
    end
    flash[:alert] = :activation_error_html
  end

  def logout
    session.delete(:id)
    session.delete(:email)
    session.delete(:search_gs)
    redirect_to :root
  end

  # GET /users/1
  # GET /users/1.json
  def show
    # session[:return_to] = '/'
    # session[:return_to] = request.referer unless request.original_fullpath.to_s.in?(request.referer.to_s)
    if @current_user.nil? or (@current_user.id.to_i != params[:id].to_i and not @current_user.can_access?('user_show'))
      flash[:alert] = t :no_access
      redirect_to :root and return
    end
    @user = User.find(params[:id])
    if @current_user.profile.id.to_i > @user.profile.id.to_i and @current_user.id.to_i != @user.id.to_i
      flash[:alert] = t :no_access
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
    # session[:return_to] = '/'
    # session[:return_to] = request.referer unless request.original_fullpath.to_s.in?(request.referer.to_s)
    @user = User.new
    respond_to do |format|
      format.html { render action: 'new' }
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    # session[:return_to] = '/'
    # session[:return_to] = request.referer unless request.original_fullpath.to_s.in?(request.referer.to_s)
    if @current_user.nil? or (@current_user.id.to_i != params[:id].to_i and not @current_user.can_access?('user_edit'))
      flash[:alert] = t :no_access
      redirect_to :root and return
    end
    @user = User.find(params[:id])
    if @current_user.profile.id.to_i > @user.profile.id.to_i and @current_user.id.to_i != @user.id.to_i
      flash[:alert] = t :no_access
      redirect_to :root and return
    end
  end

  # POST /users
  # POST /users.json
  def create
    if request.referer.nil? or (@current_user != nil and not @current_user.can_access?('user_create'))
      flash[:alert] = t :no_access
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
      warning_message = '<h4>Registration failed because:</h4>'
      flash[:alert] = (warning_message + warning_list).html_safe

      @user = User.new
      redirect_to :root and return
    end
    if @current_user == nil or @current_user.can_access?('user_create')
      @user_info = UserInfo.create(:user_id => @user.id)
      UserMailer.welcome_email(@user, @user_info.token, request.base_url).deliver_now
    end
    notices = ["#{t :welcome} #{params[:user][:username]}!", (t :activation_email)]
    redirect_to(root_url, :notice => notices.join('<br/>'))
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @current_user.nil? or (@current_user.id.to_i != params[:id].to_i and not @current_user.can_access?('user_edit'))
      flash[:alert] = t :no_access
      redirect_to :root and return
    end
    @user = User.find(params[:id])
    if @current_user.profile.id.to_i > @user.profile.id.to_i and @current_user.id.to_i != @user.id.to_i
      flash[:alert] = t :no_access
      redirect_to :root and return
    end
    respond_to do |format|
      if @user.update(user_params) and @user.user_info.update(user_params[:user_info_attributes])
        if @current_user != @user and @current_user.can_access?('user_edit')
          if (admin_params[:profile_id].to_i != @user.profile_id.to_i)
            @user.history_user_infos.create({user_email: @user.email, admin: @current_user.id,
                                             from_value: @user.profile_id, to_value: admin_params[:profile_id],
                                             change_type: 'profile'})
          end
          @user.update(admin_params)
        end
        format.html { redirect_to @user, notice: (t :user_updated) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @current_user.nil? or (@current_user.id.to_i != params[:id].to_i and not @current_user.can_access?('user_delete'))
      flash[:alert] = t :no_access
      redirect_to :root and return
    end
    @user = User.find(params[:id])
    if @current_user.profile.id.to_i > @user.profile.id.to_i and @current_user.id.to_i != @user.id.to_i
      flash[:alert] = t :no_access
      redirect_to :root and return
    end

    @user.user_info.deleted = 1
    if @user.user_info.save!
      if @current_user.can_access?('user_delete')
        @user.history_user_infos.create({user_email: @user.email, admin: @current_user.id, from_value: 0, to_value: 1,
                                         change_type: 'deletion', comment: params[:comment]})

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
        flash[:alert] = "#{(t :user_delete_error)} #{(t :try_again)} #{(t :error_persists)}"
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

  def autocomplete
    @users = nil
    unless @current_user.nil?
      if @current_user.owner?
        @users = User.select('email').where('id != ?', @current_user.id).order('email')
      elsif @current_user.admin?
        @users = User.select('email').where('id != ? AND profile_id >= ?', @current_user.id, 2).order('email')
        # @users = User.order('profile_id, username').where('profile_id >= ?', 2)
        # @users = User.find(:all, :conditions => ['profile_id >= ?', 2], :order => 'profile_id, username')
      else
        @users = User.select('email').where('id != ? AND profile_id >= ?', @current_user.id, 3).order('email')
      end
    end

    respond_to do |format|
      format.js {}
      format.json { render json: @users }
    end
  end

  def forgot_pass
    @user = User.new
  end

  def password_recovery
    error = false
    if (params[:user][:username].empty? and params[:user][:email].empty?) or
        (not params[:user][:username].empty? and not params[:user][:email].empty?)
      flash[:alert] = t :rec_both_empty
      error = true
    elsif not params[:user][:email].empty? and not params[:user][:email].match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
      flash[:alert] = t :valid_email_error
      error = true
    end

    unless error
      @user = User.where('username = ? OR email = ?', params[:user][:username], params[:user][:email]).first
      if @user
        random_token = SecureRandom.urlsafe_base64(nil, false)
        @user.update(:password => Digest::SHA1.hexdigest(random_token[0..7]))
        UserMailer.recovery_email(@user, random_token[0..7]).deliver_now
        flash[:notice] = t :pass_recov_success
      else
        flash[:alert] = t :user_not_exist
      end
    end

    respond_to do |format|
      if error
        format.html { redirect_to forgot_pass_path }
      else
        format.html { redirect_to root_path }
      end
    end
  end

  def change_pass
    error = false
    alert = []
    if Digest::SHA1.hexdigest(params[:user][:current_password]) != @current_user.password
      alert << (t :error_pass_current)
      error = true
    elsif params[:user][:new_password] != params[:user][:confirm_password]
      alert << (t :error_pass_not_match)
      error = true
    elsif params[:user][:new_password].empty? and params[:user][:confirm_password].empty?
      alert << (t :error_pass_new_empty)
      error = true
    end

    unless error
      new_pass = Digest::SHA1.hexdigest(params[:user][:new_password])
      if @current_user.update(:password => new_pass)
        flash[:notice] = (t :pass_change_success)
        return logout
      else
        flash[:alert] = "#{(t :pass_change_error)} #{(t :try_again)} #{(t :error_persists)}"
      end
    else
      flash[:alert] = alert.join('<br/>')
    end


    respond_to do |format|
      format.html { redirect_to edit_user_path }
    end
  end

  private
    def set_referer
      session[:return_to] = '/'
      session[:return_to] = request.referer unless request.original_fullpath.to_s.in?(request.referer.to_s)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :email, :current_password, :new_password, :confirm_password,
                                   user_info_attributes: [:id, :first_name, :last_name, :language_id, :deleted])
    end

    def admin_params
      params.require(:user).permit(:profile_id, user_info_attributes: [:id, :activated, :blacklisted])
    end
end