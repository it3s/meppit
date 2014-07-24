class GeoDataController < ApplicationController
  include ObjectController

  before_action :require_login, only: [:edit, :update, :add_map]

  def maps
    @maps = paginate @geo_data.maps
    render layout: nil if request.xhr?
  end

  def add_map
    add_mapping_to Map
  end
end
