class ContributingsController < ApplicationController

  before_action :find_contributable, :only => [:contributors, :contributions]

  def contributors
    @contributors = paginate @contributable.contributors
  end

  def contributions
    @contributions = paginate @contributable.contributions
  end

  private

  def find_contributable
    @contributable = find_polymorphic_object
  end

end
