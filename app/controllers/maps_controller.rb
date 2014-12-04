class MapsController < ObjectsController
  before_action :require_login, except: [:index, :show, :geo_data, :search_by_name, :tile]
  before_action :geo_data_list, only:   [:show, :edit, :new]

  def create
    _params = cleaned_params.merge(administrator: current_user)
    save_object @map, _params
  end

  def geo_data
    @geo_data_collection = paginate @map.geo_data
    render layout: nil if request.xhr?
  end

  def add_geo_data
    add_mapping_to GeoData
  end

  def remove_geo_data
    remove_mapping_to GeoData
  end

  def tile
    content = ''
    collection = @map.try(:geo_data).tile(params[:x].to_i, params[:y].to_i, params[:zoom].to_i)
    content = collection unless collection.nil?
    render json: content
  end

  private

    def geo_data_list
      @geo_data_collection ||= paginate @map.try(:geo_data), params[:data_page]
    end
end
