class ContributingsController < ApplicationController

  layout :contributors_layout

  before_action :find_parent, :only => [:contributors, :contributions]

  def contributors
    @contributors = @_object.contributors.page(params[:page]).per(params[:per])
    render :layout => nil if request.xhr?  # render template without layout
  end

  def contributions
    @contributions = @_object.contributions.page(params[:page]).per(params[:per])
    render :layout => nil if request.xhr?  # render template without layout
  end

  private

  def find_parent
    params.each do |name, value|
      if name =~ /(.+)_id$/
        begin
          _class = $1.classify.constantize
        rescue NameError
          _class = $1.classify.pluralize.constantize
        end
        @_object = _class.find(value)
        instance_variable_set "@#{_class.name.underscore}", @_object
      end
    end
  end

  def contributors_layout
    !request.xhr? ? @_object.class.name.pluralize.underscore : false
  end
end
