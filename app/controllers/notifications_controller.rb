class NotificationsController < ApplicationController

  def notifications
    @notifications = Notification.where(user: current_user)
    render layout: nil if request.xhr?
  end

end
