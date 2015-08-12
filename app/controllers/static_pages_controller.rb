class StaticPagesController < ApplicationController
  before_action :valid_user, only: [:search]

  def index
    redirect_to projects_path unless @current_user.nil?
    @user = User.new
  end

  def search
    if params[:q].nil? or params[:q].empty?
      @users = []
      @projects = []
    else
      @users = User.where("id != :id AND (username LIKE :username OR email LIKE :email) AND profile_id >= :user_profile", id: @current_user.id, username: "#{params[:q]}%", email: "#{params[:q]}%", user_profile: @current_user.profile_id)
      @projects = Project.where("title LIKE :title AND is_private = :private", { title: "%#{params[:q]}%", private: 0 })
    end

    respond_to do |format|
      format.html { render 'static_pages/search' }
	  	format.json { render json: { :users => @users, :projects => @projects } }
		end
  end

  private

  def valid_user
    if @current_user.nil?
      flash[:alert] = (t :search_restriction)
      redirect_to :root and return
    end
  end
end