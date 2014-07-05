class GeoDataController < ApplicationController
  include ContributableController

  before_action :require_login, only: [:edit, :update]
  before_action :find_geo_data, only: [:show, :edit, :update]

  def index
    @geo_data_collection = GeoData.page(params[:page]).per(params[:per])
    respond_to do |format|
      format.html
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

  protected

  def after_update
    save_contribution @geo_data, current_user
  end

  private

  def data_params
    params.require(:geo_data).permit(:name, :description).tap do |whitelisted|
      whitelisted[:contacts]  = cleaned_contacts params[:geodata]
      whitelisted[:tags] = cleaned_tags params[:geo_data]
    end
  end

  def find_geo_data
    @geo_data = GeoData.find params[:id]
  end

end
