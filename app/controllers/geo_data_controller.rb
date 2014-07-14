class GeoDataController < ApplicationController
  before_action :require_login, only:   [:edit, :update, :add_to_map]
  before_action :find_geo_data, except: [:index]

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
    # TODO implement-me
    puts "\n\n#{params}\n"
    puts "\n\nID: #{params[:map]}\n\n"
    msg = flash_xhr t('geo_data.add_to_map.added', map: 'MapName')
    render json: {flash: msg}
  end

  private

  def data_params
    params.require(:geo_data).permit(:name, :description).tap do |whitelisted|
      whitelisted[:contacts]  = cleaned_contacts params[:geo_data]
      whitelisted[:tags] = cleaned_tags params[:geo_data]
    end
  end

  def find_geo_data
    @geo_data = GeoData.find params[:id]
  end
end
