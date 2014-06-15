class ContributingsController < ApplicationController

  layout :contributings_layout

  before_action :find_contributable, :only => [:contributors, :contributions]

  def contributors
    @contributors = paginated @contributable.contributors
  end

  def contributions
    @contributions = paginated @contributable.contributions
  end

  private

  def find_contributable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        begin
          _class = $1.classify.constantize
        rescue NameError
          # Try pluralized version because we have a model in plural: "geo_data"
          _class = $1.classify.pluralize.constantize
        end
        @contributable = _class.find(value)
        # Set the variable name following our adopted standard
        instance_variable_set "@#{_class.name.underscore}", @contributable
      end
    end
  end

  def paginated collection
    collection.page(params[:page]).per(params[:per])
  end

  def contributings_layout
    unless request.xhr? then @contributable.class.name.pluralize.underscore else false end
  end
end
