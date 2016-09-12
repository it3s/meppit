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
    ['edit', 'new'].include? params[:action]
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

  def featured_button_options_for(obj)
    {
      featured: obj.featured?,
      url: url_for([obj, :featured]),
      id: identifier_for(obj)
    }.to_json
  end

  def remove_button_options_for(obj, parent)
    route = "remove_#{obj.class.name.underscore}"
    {
      url: url_for([route, parent]),
      id: identifier_for(obj),
      parentId: identifier_for(parent)
    }.to_json
  end

  def export_path_for(obj, format)
    if obj.nil?
      ctrl = controller_name == 'geo_data' ? 'geo_data_index' : controller_name
      polymorphic_path([:bulk_export, ctrl], format: format)
    else
      polymorphic_path([:export, obj], format: format)
    end
  end

  def tag_path_for(obj, tag)
    cls = obj.class == User ? GeoData : obj.class
    url_for([cls, list_filter: {tags: tag}])
  end

  def collection_location(collection)
    ids = collection.map { |item| item.is_a?(Map) ? item.geo_data.pluck(:id) : item.id }.flatten.uniq
    geo_data = GeoData.where(id: ids)

    features = geo_data.map { |data| ::GeoJSON::feature_from_model(data) }
    location = features.empty? ? nil : ::GeoJSON::encode_feature_collection(features)

    OpenStruct.new(location: location, location_geojson: location.try(:to_json))
  end

  def show_imports?(user)
    logged_in? && user == current_user && !@imports.empty?
  end

  def render_activity(activity, user = nil)
    if user
      render 'activities/user_activity', activity: ActivityPresenter.new(object: activity, ctx: self)
    else
      render 'activities/activity', activity: ActivityPresenter.new(object: activity, ctx: self)
    end
  end

  def get_mapbox_token
    ENV['MAPBOX_TOKEN'].to_s
  end
end
