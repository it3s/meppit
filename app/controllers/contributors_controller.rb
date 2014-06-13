class ContributorsController < ApplicationController

  layout :contributors_layout

  before_action :find_parent, :only => [:index]

  def index
    @list = @object.contributors.page(params[:page]).per(params[:per])
    render :layout => nil if request.xhr?  # render template without layout
  end

  private

  def find_parent
    params.each do |name, value|
      @object = $1.classify.pluralize.constantize.find(value) if name =~ /(.+)_id$/
    end
  end

  def contributors_layout
    !request.xhr? ? @object.class.name.underscore : false
  end
end
