module API
  class GeoDataController < APIController
    before_action :authenticate_or_resquest

    respond_to :json, :xml

    def show
      respond_with GeoData.find(params[:id])
    end

    def index
      respond_with GeoData.all
    end
  end
end
