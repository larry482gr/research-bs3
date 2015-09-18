#
# Copyright 2015 Kazantzis Lazaros
#

class UserMailer < ActionMailer::Base
  require 'uri'
  default from: 'no-reply@research.org.gr'

  def welcome_email(user, token, baseUrl)
    @user = user
    @url  = "#{baseUrl}/activate?user=#{@user.username}&token=#{token}"
    mail(to: @user.email, subject: (t 'email_deliver.subject.welcome'))
  end

  def invite_email(project, email, current_user)
    @project = project
    @current_user = current_user
    mail(to: email, subject: (t 'email_deliver.subject.invitation').gsub('%username%', @current_user.username))
  end

  def recovery_email(user, token)
    @user = user
    @token = token
    mail(to: @user.email, subject: (t 'email_deliver.subject.recover'))
  end
end