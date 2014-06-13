class ContributorsController < ApplicationController

  layout :contributors_layout

  before_action :find_data,     :only => [:index]

  def index
    @list = @data.contributors.page(params[:page]).per(params[:per])
    render :layout => nil if request.xhr?  # render template without layout
  end

  private

  def find_data
    @data = GeoData.find params[:geo_datum_id]
  end

  def contributors_layout
    layout = @data.kind_of?(GeoData) ? "geo_data" : nil
    !request.xhr? ? layout : false
  end
end
