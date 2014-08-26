class NotificationsController < ApplicationController
  before_action :require_login

  def notifications
    @notifications = paginate current_user.notifications
    render layout: nil if request.xhr?
  end

  def read
    notifications_ids = params[:notifications_ids].map &:to_i
    Notification.where(id: notifications_ids, user_id: current_user.id).update_all status: "read"
    render json: {ok: true}
  end

end
