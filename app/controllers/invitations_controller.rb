#
# Copyright 2015 Kazantzis Lazaros
#

class InvitationsController < ApplicationController
  before_action :valid_user

  # GET /invitations
  # GET /invitations.json
  def index
    invitations = Invitation.where('email = ? AND status = ?', @current_user.email, 'pending')
    invitations_array = []

    invitations.each do |inv|
      user = User.find(inv.from_user)
      user_hash = { :id => @current_user.id, :email => user.email, :first_name => user.user_info.first_name, :last_name => user.user_info.last_name }

      project = Project.find(inv.project_id)
      project_hash = { :id => project.id , :project_title => project.title, :project_profile => inv.project_profile_id }

      invitations_array << { :id => inv.id, :user => user_hash, :project => project_hash, :date => "#{l inv.created_at, format: :long}" }
    end

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: invitations_array }
    end
  end

  # POST /invitations
  # POST /invitations.json
  def create
    @project = Project.find(params[:project_id])

    if not @project.owner?(@current_user.id)
      flash[:alert] = t :no_invitation_access
      redirect_to project_path(@project) and return
    end

    @user = User.find_by_username(params[:invitation][:username])

    email = @user ? @user.email : params[:invitation][:email]

    if email.nil? or not email.match(User::VALID_EMAIL_REGEX)
      error_msg = t :invitation_user_restriction
      alert = error_msg
    else
      begin
        @invitation = @project.invitations.create(email: email, from_user: @current_user.id, project_id: @project.id)
        if @invitation.save
          notice = "#{(t :invitation_sent)} #{email}"
          # UserMailer.welcome_email(@user, @user_info.token, request.base_url).deliver_now
          UserMailer.invite_email(@project, email, @current_user).deliver_now
        else
          alert = "#{(t :invitation_fail)} #{(t :try_again)} #{(t :error_persists)}"
        end
      rescue ActiveRecord::RecordNotUnique
        error_msg = (t :invitation_duplicate).to_s.gsub('_@user@_', @user.username).gsub('_@project@_', @project.title)
        alert = error_msg
      end
    end

    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: notice, alert: alert }
      format.json { render action: 'show', status: :created, location: project_path(@project) }
    end
  end

  def update
    user = User.find(params[:user_id])

    if @current_user.id.to_i != user.id.to_i
      error_code = -1
      respond_to do |format|
        format.html { redirect_to root_path, alert: error_code }
        format.json { render json: "{ \"error_code\": #{error_code} }" }
      end
      return
    end

    invitation = Invitation.find(params[:id])
    if params[:invitation][:reason].empty?
      params[:invitation][:reason] = nil
    end

    if invitation.update(invitation_params)
      error_code = 0
      if invitation.status.to_s == 'accepted'
        error_code = 1 unless invitation.project.add_user(@current_user, invitation.project_profile.id)
      elsif invitation.status.to_s == 'reported'
        inv_sender = User.find(invitation.from_user)
        user_reports = inv_sender.user_info.reports + 1
        error_code = 1 unless inv_sender.user_info.update(:reports => user_reports)
        if user_reports >= 10
          error_code = 1 unless inv_sender.user_info.update(:blacklisted => 1)
        end
      end
    else
      error_code = 1
    end

    total = Invitation.where('email = ? AND status = ?', @current_user.email, 'pending').count
    respond_to do |format|
      format.html { redirect_to root_path, notice: error_code }
      format.json { render json: "{ \"error_code\": #{error_code}, \"status\": \"#{params[:invitation][:status]}\", \"total\": #{total} }" }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def invitation_params
    # params.require(:invitation).permit(:email, :profile, :status, :reason)
    params.require(:invitation).permit(:username, :email, :status, :reason)
  end

  def valid_user
    if @current_user.nil?
      flash[:alert] = :no_access
      redirect_to :root and return
    end
  end
end
