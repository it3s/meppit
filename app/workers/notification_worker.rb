class NotificationWorker
  include Sidekiq::Worker

  def perform(activity_id)
    activity = PublicActivity::Activity.includes(:trackable, :owner).find(activity_id)
    users_to_receive_notification(activity).each do |user_id|
      if user_id != activity.owner_id
        notification = Notification.create activity: activity, user_id: user_id
        notification.rt_notify
      end
    end
  end

  private

    ADMIN_ACTIONS = ['flag']

    def users_to_receive_notification(activity)
      ids = []

      if ADMIN_ACTIONS.include?(action activity)
        ids = Admin.pluck(:user_id)
      else
        # For content
        ids.concat activity.trackable.try(:followers   ).try(:pluck, :id) || []
        ids.concat activity.trackable.try(:contributors).try(:pluck, :id) || []

        # For followed user
        ids.concat activity.owner.try(:followers   ).try(:pluck, :id) || []
      end
      ids.uniq
    end

    def action(activity)
      activity.key.split('.').last
    end
end
