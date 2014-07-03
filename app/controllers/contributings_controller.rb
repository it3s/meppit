class ContributingsController < ApplicationController

  before_action :find_contributable, :only => [:contributors, :contributions]

  def contributors
    @contributors = paginate @contributable.contributors
    render layout: nil if request.xhr?
  end

  def contributions
    @contributions = paginate @contributable.contributions
    render layout: nil if request.xhr?
  end

  private

  def find_contributable
    @contributable = find_polymorphic_object
  end

end
