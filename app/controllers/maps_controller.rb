class MapsController < ApplicationController
  before_action :require_login, only: [:edit, :update]
  before_action :find_map,      only: [:show, :edit, :update, :geo_data]
  before_action :geo_data_list, only: [:show]

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

  def search_by_name
    # TODO implement-me
    puts "\n\n#{params}\n"
    render json: (1..10).map {|i| {value: "bla #{i}", id: i} }
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

end
