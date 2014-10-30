class FlagsController < ApplicationController
  before_action :require_login

  def new
    @flag = Flag.new
    render layout: nil if request.xhr?
  end

  def create
  end

end
