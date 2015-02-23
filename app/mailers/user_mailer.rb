class UserMailer < ActionMailer::Base
  require 'uri'
  default from: "no-reply@researchgr.com"
  
  def welcome_email(user, token, baseUrl)
    @user = user
    @url  = "#{baseUrl}/activate?user=#{@user.username}&token=#{token}"
    mail(to: @user.email, subject: 'Activate your account to ResearchGr')
  end
end
