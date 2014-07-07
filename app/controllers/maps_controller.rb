class MapsController < ApplicationController
  before_action :require_login, only: [:edit, :update]
  before_action :find_map, only: [:show, :edit, :update]

  def index
    @maps_collection = Map.page(params[:page]).per(params[:per])
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
    update_object @map, map_params
  end

  private

  def map_params
    params.require(:map).permit(:name, :description).tap do |whitelisted|
      whitelisted[:contacts]  = cleaned_contacts params[:map]
      whitelisted[:tags] = cleaned_tags params[:map]
    end
  end

  def find_map
    @map = Map.find params[:id]
  end

end
