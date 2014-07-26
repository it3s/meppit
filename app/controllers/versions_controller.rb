class VersionsController < ApplicationController
  before_action :find_versionable, only: [:history]
  before_action :require_login,    only: [:revert]

  def history
    @versions = @versionable.versions
    render layout: nil if request.xhr?
  end


  def revert
    @version = PaperTrail::Version.find(params[:id])
    object = @version.reify
    object.save!
    redirect_to object, notice: t('versions.reverted', content: object.name)
  end


  private

  def find_versionable
    @versionable = find_polymorphic_object
  end

end
