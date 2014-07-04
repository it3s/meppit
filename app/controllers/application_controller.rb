class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  before_action :set_locale, :except => :language

  def language
    code = params[:code]
    if I18n.available_locales.include? code.to_sym
      current_user.update(:language => code) if current_user
      session[:language] = code
    end
    redirect_to :back
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

  def to_bool(string)
    return true if string == true || string =~ (/(true|t|yes|y|1)$/i)
    return false if string == false || string.nil? || string =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{string}\"")
  end

  def update_object(obj, params_hash)
    obj.assign_attributes(params_hash)
    if obj.valid? && obj.save
      after_update() if self.class.method_defined? :after_update
      flash[:notice] = t('flash.updated')
      render :json => {:redirect => polymorphic_path([obj])}
    else
      render :json => {:errors => obj.errors.messages}, :status => :unprocessable_entity
    end
  end

  def find_polymorphic_object
    resource, id = request.path.split('/')[1..2]
    _model = resource.classify.constantize
    instance_variable_set "@#{_model.name.underscore}", _model.find(id)  # set var and return the obj
  end

  def paginate(collection)
    collection.page(params[:page]).per(params[:per])
  end
end
