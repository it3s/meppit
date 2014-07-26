class VersionsController < ApplicationController
  before_action :require_login,    only: [:revert]
  before_action :find_versionable, only: [:history]
  before_action :find_version,     only: [:revert]

  def history
    @versions = @versionable.versions
    render layout: nil if request.xhr?
  end


  def revert
    object = revert_to_version!
    redirect_to object, notice: t('versions.reverted', content: object.name)
  end


  private

  def find_versionable
    @versionable = find_polymorphic_object
  end

  def find_version
    @version = PaperTrail::Version.find(params[:id])
  end

  def revert_to_version!
    object = @version.reify
    object.location = version_location if object.has_attribute?(:location)
    object.save!
    object
  end

  def version_location
    (SafeYAML.load(@version.object)["location"] || {})["wkt"]
  end

end
