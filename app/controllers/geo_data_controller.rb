class GeoDataController < ApplicationController
  before_action :require_login, only:   [:edit, :update, :add_to_map]
  before_action :find_geo_data, except: [:index, :search_by_name]

  def index
    @geo_data_collection = GeoData.page(params[:page]).per(params[:per])
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
    update_object @geo_data, data_params
  end

  def maps
    @maps = paginate @geo_data.maps
    render layout: nil if request.xhr?
  end

  def add_to_map
    if map = Map.find_by(id: params[:map])
      _mapping, msg = create_mapping map
      render json: {flash: flash_xhr(msg), count: @geo_data.maps_count}
    else
      msg = t('geo_data.add_to_map.invalid')
      render json: {flash: flash_xhr(msg)}, status: :unprocessable_entity
    end
  end

  def search_by_name
    search_result = GeoData.search_by_name params[:term]
    render json: search_result.map { |geo_data| {value: geo_data.name, id: geo_data.id} }
  end

  private

  def data_params
    params.require(:geo_data).permit(:name, :description).tap do |whitelisted|
      whitelisted[:contacts]  = cleaned_contacts params[:geo_data]
      whitelisted[:tags] = cleaned_tags params[:geo_data]
      whitelisted[:additional_info] = cleaned_additional_info params[:geo_data]
    end
  end

  def find_geo_data
    @geo_data = GeoData.find params[:id]
  end

  def create_mapping(map)
    mapping = @geo_data.add_to_map map
    msg_type = mapping.id ? 'added' : 'exists'
    [mapping, t("geo_data.add_to_map.#{msg_type}", map: map.name)]
  end
end
