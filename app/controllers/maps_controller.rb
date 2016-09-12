class MapsController < ObjectsController
  before_action :require_login, except: [:index, :show, :geo_data, :search_by_name, :tile]
  before_action :geo_data_list, only:   [:show, :new, :edit, :geo_data]

  def create
    _params = cleaned_params.merge(administrator: current_user)
    save_object @map, _params
  end

  def geo_data
    render layout: nil if request.xhr?
  end

  def add_geo_data
    add_mapping_to GeoData
  end

  def remove_geo_data
    remove_mapping_to GeoData
  end

  def tile
    @geo_data_collection = @map.geo_data.filter(filter_params).tile(params[:zoom].to_i, params[:x].to_i, params[:y].to_i)
    render geojson: @geo_data_collection
  end

  private

    def geo_data_list
      @geo_data_collection ||= paginate @map.geo_data, params[:data_page]
    end
end
