class UserMailer < ActionMailer::Base
  require 'uri'
  default from: "no-reply@research.org.gr"
  
  def welcome_email(user, token, baseUrl)
    @user = user
    @url  = "#{baseUrl}/activate?user=#{@user.username}&token=#{token}"
    mail(to: @user.email, subject: 'Activate your account to research.org.gr')
  end

  def invite_email(project, user, current_user)
    @project = project
    @user = user
    @current_user = current_user
    mail(to: @user.email, subject: "Invitation from #{@current_user.username} at research.org.gr", reply_to: @current_user.email)
  end
end
