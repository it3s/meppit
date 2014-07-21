class ApplicationController < ActionController::Base
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
    render partial: 'shared/search_results', layout: nil
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
      obj_name = obj.class.name.underscore
      EventBus.publish "#{obj_name}_updated", obj_name.to_sym => obj, current_user: current_user
      flash[:notice] = t('flash.updated')
      render json: {redirect: polymorphic_path([obj])}
    else
      render json: {errors: obj.errors.messages}, status: :unprocessable_entity
    end
  end

  def find_polymorphic_object
    resource, id = request.path.split('/')[1..2]
    _model = resource.classify.constantize
    instance_variable_set "@#{_model.name.underscore}", _model.find(id)  # set var and return the obj
  end

  def paginate(collection, page = nil, per = nil)
    page ||= params[:page]
    per  ||= params[:per]
    collection = Kaminari.paginate_array collection if collection.kind_of? Array
    collection.try(:page, page).try(:per, per)
  end

  def cleaned_contacts(_params)
    _params ||= {}
    (_params[:contacts]  || {}).delete_if { |key, value| value.blank? }
  end

  def cleaned_tags(_params, field_name=:tags)
    (_params[field_name] || '').split(',')
  end

  def flash_xhr(msg)
    flash.now[:notice] = msg
    render_to_string(partial: 'shared/alerts')
  end
end
