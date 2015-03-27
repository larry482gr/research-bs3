class InvitationsController < ApplicationController
  before_action :valid_user
  before_action :set_invitation, only: [:show, :update]

  # GET /invitations
  # GET /invitations.json
  def index
    invitations = @current_user.invitations.where('status = ?', 'pending')
    invitations_array = []

    invitations.each do |inv|
      user = User.find(inv.from_user)
      user_hash = { :id => @current_user.id, :email => user.email, :first_name => user.user_info.first_name, :last_name => user.user_info.first_name }

      project = Project.find(inv.project_id)
      project_hash = { :project_title => project.title, :project_profile => inv.project_profile_id }

      invitations_array << { :id => inv.id, :user => user_hash, :project => project_hash, :date => "#{l inv.created_at, format: :long}" }
    end

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: invitations_array }
    end
  end

  def show
    @invitation = Invitation.find(params[:id])
  end

  # GET /invitations/new
  def new
    redirect_to project_path(Project.find(params[:project_id]))
  end

  # POST /invitations
  # POST /invitations.json
  def create
    @project = Project.find(params[:project_id])

    if not @project.owner?(@current_user.id)
      flash[:alert] = :no_invitation_access
      redirect_to project_path(@project) and return
    end

    @user = User.find_by_email(params[:invitation][:email])

    @invitation = @project.invitations.create(user_id: @user.id, from_user: @current_user.id, project_id: @project.id, project_profile_id: params[:invitation][:profile])
    if @invitation.save
      notice = "#{(t :invitation_sent)} #{@user.username}"
    else
      alert = "#{(t :invitation_fail)} #{(t :try_again)} #{(t :error_persists)}"
    end

    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: notice, alert: alert }
      format.json { render action: 'show', status: :created, location: project_path(@project) }
    end
  end

  def update
    user = User.find(params[:user_id])
    if @current_user.id != user.id
      error_code = -1
      respond_to do |format|
        format.html { redirect_to root_path, alert: error_code }
        format.json { render json: "{ \"error_code\": #{error_code} }" }
      end
      return
    end

    invitation = Invitation.find(params[:id])
    if invitation.update(invitation_params)
      error_code = 0
      if invitation.status.to_s == 'accepted'
        error_code = 1 unless invitation.project.add_user(invitation.user.id, invitation.project_profile.id)
      end
    else
      error_code = 1
    end

    total = @current_user.invitations.where('status = ?', 'pending').count
    respond_to do |format|
      format.html { redirect_to root_path, notice: error_code }
      format.json { render json: "{ \"error_code\": #{error_code}, \"status\": \"#{params[:invitation][:status]}\", \"total\": #{total} }" }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def invitation_params
    params.require(:invitation).permit(:email, :profile, :status)
  end

  def valid_user
    if @current_user.nil?
      flash[:alert] = :no_access
      redirect_to :root and return
    end
  end
end