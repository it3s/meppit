class NotificationsController < ApplicationController

  def notifications
    @notifications = paginate current_user.notifications
    render layout: nil if request.xhr?
  end

end
