class DownloadsController < ApplicationController

  before_action :find_downloadable

  def export
    respond_to do |format|
      format.json    { download_file :json }
      format.geojson { download_file :geojson }
      format.csv     { download_file :csv }
      format.xml     { download_file :xml }
    end
  end

  private

    def find_downloadable
      @downloadable = find_polymorphic_object
    end

    def filename(_type)
      "#{@downloadable.class.name.underscore}_#{@downloadable.id}.#{_type}"
    end

    def download_file(_type)
      send_data @downloadable.send(:"to_#{_type}"), filename: filename(_type)
    end
end
