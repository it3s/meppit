class NotificationWorker
  include Sidekiq::Worker

  def perform(activity_id)
    # TODO implement-me
    puts "ADD notifications for #{activity_id}"
  end
end
