#
# Copyright 2015 Kazantzis Lazaros
#

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :set_current_user
  before_action :set_locale

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { locale: I18n.locale }
  end

  def set_current_user
    # force_ssl_redirect and return unless session[:id]
    @current_user ||= User.find_by('password = ? AND email = ?', session[:id], session[:email])
    unless @current_user.nil?
      @current_user = nil unless (@current_user.user_info.activated? and
          not (@current_user.user_info.blacklisted? or @current_user.user_info.deleted?))
    end
  end

  def set_locale
    if @current_user != nil
      begin
        language = Language.find(@current_user.language.id)
        params[:locale] = language.locale
      rescue ActiveRecord::RecordNotFound
        params[:locale] = 'en'
      end
    end
    I18n.locale = params[:locale]
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
