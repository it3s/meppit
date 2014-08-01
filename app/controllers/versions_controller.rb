class VersionsController < ApplicationController
  before_action :require_login,            only: [:revert]
  before_action :find_versionable,         only: [:history]
  before_action :find_version,             only: [:revert, :show]
  before_action :build_object_for_version, only: [:show]
  before_action :build_map_geo_data,       only: [:show]

  def history
    @versions = paginate @versionable.versions.reorder('created_at desc')
    respond_to do |format|
      format.html
      format.js
    end
  end


  def revert
    object = revert_to_version!
    redirect_to object, notice: t('versions.reverted', content: object.name)
  end

  def show
    render layout: nil
  end

  private

  def find_versionable
    @versionable = find_polymorphic_object
  end

  def find_version
    @version = PaperTrail::Version.find(params[:id])
  end

  def build_object_for_version
    @object = reified_object
  end

  def build_map_geo_data
    @geo_data_collection ||= paginate(@object.try(:geo_data), params[:data_page]) if @object.class.name == 'Map'
  end

  def revert_to_version!
    object = reified_object
    object.save!
    object
  end

  def reified_object
    object = @version.reify
    object.location = version_location if object.has_attribute?(:location)
    object
  end

  def version_location
    (SafeYAML.load(@version.object)["location"] || {})["wkt"]
  end

end
