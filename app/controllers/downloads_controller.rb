class DownloadsController < ApplicationController

  before_action :find_downloadable, only: [:export]
  before_action :find_model,        only: [:bulk_export]

  FORMATS = [:json, :geojson, :csv, :xml]

  def export
    respond_to_formats
  end

  def bulk_export
    @bulk = true
    respond_to_formats
  end

  private

    def find_downloadable
      @downloadable = find_polymorphic_object
    end

    def find_model
      @model = find_polymorphic_model
    end

    def respond_to_formats
      respond_to do |fmt|
        FORMATS.each { |format| fmt.send(format) { download_resource format } }
      end
    end

    def filename(format)
      if @bulk
        "#{@model.name.underscore}.#{format}"
      else
        "#{@downloadable.class.name.underscore}_#{@downloadable.id}.#{format}"
      end
    end

    def download_resource(format)
      target = @bulk ? @model : @downloadable
      send_data target.serialized_as(format), filename: filename(format)
    end

end
