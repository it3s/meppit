class GeoDataController < ApplicationController

  before_action :require_login, :only => [:edit, :update]
  before_action :find_data,     :only => [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    @data.assign_attributes(data_params)
    if @data.valid? && @data.save
      flash[:notice] = t('geo_data.flash.updated')
      render :json => {:redirect => geo_datum_path(@data)}
    else
      render :json => {:errors => @data.errors.messages}, :status => :unprocessable_entity
    end
  end


  private

  def data_params
    params.require(:geo_data).permit(:name, :description).tap do |whitelisted|
      whitelisted[:contacts]  = (params[:geodata][:contacts]  || {}).delete_if { |key, value| value.blank? }
      whitelisted[:tags] = (params[:geo_data][:tags] || '').split(',')
    end
  end

  def find_data
    @data = GeoData.find params[:id]
  end
end
