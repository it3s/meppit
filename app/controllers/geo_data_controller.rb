class GeoDataController < ObjectsController
  before_action :require_login, except: [:index, :show, :maps, :search_by_name]

  def maps
    @maps = paginate @geo_data.maps
    render layout: nil if request.xhr?
  end

  def add_map
    add_mapping_to Map
  end

  def bulk_add_map
    render json: {}
  end
end
