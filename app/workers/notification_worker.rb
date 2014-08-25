class NotificationWorker
  include Sidekiq::Worker

  def perform(activity_id)
    activity = PublicActivity::Activity.includes(:trackable, :owner).find(activity_id)
    users_to_receive_notification(activity).each do |user_id|
      Notification.create activity: activity, user_id: user_id if user_id != activity.owner_id
    end
  end

  private

    def users_to_receive_notification(activity)
      ids = []

      # For content
      ids.concat activity.trackable.try(:followers   ).try(:pluck, :id) || []
      ids.concat activity.trackable.try(:contributors).try(:pluck, :id) || []

      # For followed user
      ids.concat activity.owner.try(:followers   ).try(:pluck, :id) || []
      ids.uniq
    end
end
