class DashboardController < ApplicationController
  before_action :require_login,    only: [:dashboard]
  before_action :activities_list,  only: [:dashboard]
  before_action :maps_list,        only: [:dashboard]

  def dashboard
  end

  private

    def maps_list
      @maps ||= paginate current_user.try(:maps), params[:maps_page]
    end

    def activities_list
      @activities ||= news_feed_results
    end

end
