class MapsController < ApplicationController
  include ObjectController
  before_action :require_login, only: [:edit, :update, :add_geo_data]
  before_action :geo_data_list, only: [:show]

  def geo_data
    @geo_data_collection = paginate @map.geo_data
    render layout: nil if request.xhr?
  end


  def add_geo_data
    add_mapping_to GeoData
  end

  private

  def geo_data_list
    @geo_data_collection ||= paginate @map.try(:geo_data), params[:data_page]
  end
end
