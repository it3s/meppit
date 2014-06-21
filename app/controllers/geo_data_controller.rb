class GeoDataController < ApplicationController
  include ContributableController

  before_action :require_login, :only => [:edit, :update]
  before_action :find_geo_data, :only => [:show, :edit, :update]

  def index
    @geo_data_collection = GeoData.page(params[:page]).per(params[:per])
    respond_to do |format|
      format.html { render :layout => (request.xhr? ? false : "application") }
      format.js
    end
  end

  def show
  end

  def edit
  end

  def update
    update_object @geo_data, data_params
  end

  def after_update
    save_contribution @geo_data, current_user
  end

  private

  def data_params
    params.require(:geo_data).permit(:name, :description).tap do |whitelisted|
      whitelisted[:contacts]  = ((params[:geodata] || {})[:contacts]  || {}).delete_if { |key, value| value.blank? }
      whitelisted[:tags] = (params[:geo_data][:tags] || '').split(',')
    end
  end

  def find_geo_data
    @geo_data = GeoData.find params[:id]
  end
end
