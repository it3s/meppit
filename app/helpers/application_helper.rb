module ApplicationHelper
  include Concerns::ContactsHelper
  include Concerns::I18nHelper
  include Concerns::CountersHelper
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

  def object_type(obj)
    # TODO refactor this
    if obj.kind_of? User
      :user
    elsif obj.kind_of? GeoData
      :data
    #elsif obj.kind_of? Map
      #:map
    else
      :unknown
    end
  end

  def menu_active?(controller_name)
    _obj_ref = "#{controller_name.singularize}_id".to_sym  # "maps" => "map_id"
    params[:controller] == controller_name || params[_obj_ref]
  end

  def edit_mode?
    params[:action] == 'edit'
  end

end
