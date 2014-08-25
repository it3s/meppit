class NotificationsController < ApplicationController

  def notifications
    @notifications = paginate Notification.includes(:user, activity: [:trackable, :owner]).where(user: current_user).order('created_at desc')
    render layout: nil if request.xhr?
  end

end
