class UserMailer < ActionMailer::Base
  require 'uri'
  default from: "no-reply@research.org.gr"
  
  def welcome_email(user, token, baseUrl)
    @user = user
    @url  = "#{baseUrl}/activate?user=#{@user.username}&token=#{token}"
    mail(to: @user.email, subject: (t 'email.subject.welcome'))
  end

  def invite_email(project, user, current_user)
    @project = project
    @user = user
    @current_user = current_user
    mail(to: @user.email, subject: (t 'email.subject.invitation').gsub('%username%', @current_user.username))
  end

  def recovery_email(user, token)
    @user = user
    @token = token
    mail(to: @user.email, subject: (t 'email.subject.recover'))
  end
end
