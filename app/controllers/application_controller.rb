class ApplicationController < ActionController::Base
  include Utils

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale, except: :language

  def language
    code = params[:code]
    if I18n.available_locales.include? code.to_sym
      current_user.update(language: code) if current_user
      session[:language] = code
    end
    redirect_to :back
  end

  def search
    @results = paginate PgSearch.multisearch(params[:term]).limit(20).map { |d| d.searchable }
    render 'shared/search_results', layout: nil
  end

  def not_authenticated
    redirect_to login_path
  end

  private

  def set_locale
    I18n.locale = (current_user.try(:language) || session[:language] ||
                   extract_from_header || I18n.default_locale)
  end

  def extract_from_header
    http_accept_language.compatible_language_from(I18n.available_locales)
  end
end
