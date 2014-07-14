module ApplicationHelper
  include Concerns::ContactsHelper
  include Concerns::I18nHelper
  include Concerns::ComponentsHelper

  def javascript_exists?(script)
    script = "#{Rails.root}/app/assets/javascripts/#{script}.js"
    extensions = %w(.coffee .erb .coffee.erb) + [""]
    extensions.inject(false) do |truth, extension|
      truth || File.exists?("#{script}#{extension}")
    end
  end

  def with_http(url)
    url.starts_with?('http://') ? url : "http://#{url}"
  end

  def available_types
    @_available_types ||= [:user, :geo_data, :map]
  end

  def object_type(obj)
    _type = obj.class.name.underscore.to_sym
    available_types.include?(_type) ? _type : :unknown
  end

  def menu_active?(controller_name)
    _obj_ref = "#{controller_name.singularize}_id".to_sym  # "maps" => "map_id"
    params[:controller] == controller_name || params[_obj_ref]
  end

  def edit_mode?
    params[:action] == 'edit'
  end

  def identifier_for(obj)
    "#{object_type(obj)}##{obj.id}"
  end

  def follow_options_for(obj)
    {
      following: current_user && current_user.follow?(obj),
      url: url_for([obj, :follow]),
      id: identifier_for(obj)
    }.to_json
  end
end
