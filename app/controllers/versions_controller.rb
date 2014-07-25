class VersionsController < ApplicationController
  before_action :find_versionable

  def history
    @versions = @versionable.versions
    render layout: nil if request.xhr?
  end

  private

  def find_versionable
    @versionable = find_polymorphic_object
  end

end
