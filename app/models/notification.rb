class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity, class_name: "PublicActivity::Activity"

  validates :user, :activity, presence: true

  def self.build_notifications(activity)
    _id = activity.is_a?(PublicActivity::Activity) ? activity.id : activity
    NotificationWorker.perform_async(_id)
  end
end
