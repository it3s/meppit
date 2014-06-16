class GeoDataController < ApplicationController

  before_action :require_login, :only => [:edit, :update]
  before_action :find_data,     :only => [:show, :edit, :update]

  def index
    @list = GeoData.page(params[:page]).per(params[:per])
    respond_to do |format|
      format.html { render :layout => !request.xhr? }
      format.js
    end
  end

  def show
  end

  def edit
  end

  def update
    update_object @data, data_params
  end

  private

  def data_params
    params.require(:geo_data).permit(:name, :description).tap do |whitelisted|
      whitelisted[:contacts]  = ((params[:geodata] || {})[:contacts]  || {}).delete_if { |key, value| value.blank? }
      whitelisted[:tags] = (params[:geo_data][:tags] || '').split(',')
    end
  end

  def find_data
    @data = GeoData.find params[:id]
  end
end
