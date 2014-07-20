class MapsController < ApplicationController
  before_action :require_login, only:   [:edit, :update, :add_data]
  before_action :find_map,      except: [:index, :search_by_name]
  before_action :geo_data_list, only:   [:show]

  def index
    @maps_collection = Map.page(params[:page]).per(params[:per])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
  end

  def edit
  end

  def update
    update_object @map, map_params
  end

  def geo_data
    @geo_data_collection = paginate @map.geo_data
    render layout: nil if request.xhr?
  end

  def add_data
    if geo_data = GeoData.find_by(id: params[:geo_data])
      _mapping, msg = create_mapping geo_data
      render json: {flash: flash_xhr(msg), count: @map.data_count}
    else
      msg = t('maps.add_data.invalid')
      render json: {flash: flash_xhr(msg)}, status: :unprocessable_entity
    end
  end

  def search_by_name
    search_result = Map.search_by_name params[:term]
    render json: search_result.map { |map| {value: map.name, id: map.id} }
  end

  private

  def map_params
    params.require(:map).permit(:name, :description).tap do |whitelisted|
      whitelisted[:contacts]  = cleaned_contacts params[:map]
      whitelisted[:tags] = cleaned_tags params[:map]
    end
  end

  def geo_data_list
    @geo_data_collection ||= paginate @map.try(:geo_data), params[:data_page]
  end

  def find_map
    @map = Map.find params[:id]
  end

  def create_mapping(geo_data)
    mapping = @map.add_data geo_data
    msg_type = mapping.id ? 'added' : 'exists'
    [mapping, t("maps.add_data.#{msg_type}", data: geo_data.name)]
  end

end
