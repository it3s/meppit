class ActivitiesController < ApplicationController
  before_action :find_user, only: [:user_activity]

  def user_activity
    @activities = paginate @user.activities_performed
    render layout: nil if request.xhr?
  end

  def news_feed
    @activities = news_feed_results
  end

  private

    def find_user
      @user ||= User.find(params[:id])
    end
end
