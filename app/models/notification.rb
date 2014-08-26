class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity, class_name: "PublicActivity::Activity"

  validates :user, :activity, presence: true

  def self.build_notifications(activity)
    _id = activity.is_a?(PublicActivity::Activity) ? activity.id : activity
    NotificationWorker.perform_async(_id)
  end

  def self.publish(channel, data)
    message = { channel: channel, data: data, ext: {auth_token: ENV['FAYE_TOKEN']} }
    uri = URI.parse(ENV['FAYE_URL'])
    Net::HTTP.post_form(uri, message: message.to_json)
  end
end
