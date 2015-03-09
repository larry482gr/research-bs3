class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_current_user
  before_action :set_locale

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { locale: I18n.locale }
  end

  def set_current_user
    return unless session[:id]
    @current_user ||= User.find_by_password(session[:id])
  end

  def set_locale
    if @current_user != nil
      begin
        language = Language.find(@current_user.user_info.language_id)
        params[:locale] = language.locale
      rescue ActiveRecord::RecordNotFound
        params[:locale] = 'en'
      end
    end
    I18n.locale = params[:locale]
  end
end