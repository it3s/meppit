class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  before_action :set_locale

  def set_locale
    I18n.locale = current_user.try(:language) || extract_from_header || I18n.default_locale
  end

  def extract_from_header
    http_accept_language.compatible_language_from(I18n.available_locales)
  end
end
