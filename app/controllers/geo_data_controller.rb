class GeoDataController < ApplicationController

  before_action :require_login, :only => [:edit, :update]
  before_action :find_data,     :only => [:show, :edit, :update]

  def show
  end

  def edit
  end

  private

  def find_data
    @data = GeoData.find params[:id]
  end
end
