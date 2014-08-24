class NotificationWorker
  include Sidekiq::Worker

  def perform(activity_id)
    activity = PublicActivity::Activity.find(activity_id).includes(:trackable)
    users_to_receive_notification(activity.trackable).each do |user|
      Notification.create activity: activity, user: user
    end
  end

  private

    def users_to_receive_notification(obj)
      ids = []
      ids.concat u.try(:followers   ).try(:pluck, :id) || []
      ids.concat u.try(:contributors).try(:pluck, :id) || []
      ids.uniq
    end
end
