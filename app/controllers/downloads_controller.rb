class DownloadsController < ApplicationController

  before_action :find_downloadable

  def export
    respond_to do |format|
      format.json { render json: @downloadable.to_json }
    end
  end

  private

    def find_downloadable
      @downloadable = find_polymorphic_object
    end
end
