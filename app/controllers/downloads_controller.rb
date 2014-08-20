class DownloadsController < ApplicationController

  before_action :find_downloadable

  FORMATS = [:json, :geojson, :csv, :xml]

  def export
    respond_to do |format|
      FORMATS.each { |_type| format.send(_type) { download_file _type } }
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
      send_data @downloadable.serialize(_type), filename: filename(_type)
    end
end
