ENV["REDISTOGO_URL"] ||= "redis://localhost:6379"

Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDISTOGO_URL"] }

  database_url = ENV['DATABASE_URL']
  if database_url
    ENV['DATABASE_URL'] = "#{database_url}?pool=10"
    ActiveRecord::Base.establish_connection
  end

end


Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDISTOGO_URL"] }
  config.logger.level = Logger::WARN
end
