class DownloadsController < ApplicationController

  before_action :find_downloadable

  def export
    respond_to do |format|
      format.json    { download_file :to_json, :json }
      format.geojson { download_file :location_geojson, :geojson }
    end
  end

  private

    def find_downloadable
      @downloadable = find_polymorphic_object
    end

    def filename(_type)
      "#{@downloadable.class.name.underscore}_#{@downloadable.id}.#{_type}"
    end

    def download_file(method, _type)
      send_data @downloadable.send(method), filename: filename(_type)
    end
end
