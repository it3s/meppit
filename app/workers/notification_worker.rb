class NotificationWorker
  include Sidekiq::Worker

  def perform(activity_id)
    activity = PublicActivity::Activity.includes(:trackable).find(activity_id)
    users_to_receive_notification(activity.trackable).each do |user_id|
      Notification.create activity: activity, user_id: user_id if user_id != activity.owner_id
    end
  end

  private

    def users_to_receive_notification(obj)
      ids = []
      ids.concat obj.try(:followers   ).try(:pluck, :id) || []
      ids.concat obj.try(:contributors).try(:pluck, :id) || []
      ids.uniq
    end
end
