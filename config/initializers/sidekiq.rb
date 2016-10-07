ENV["REDIS_URL"] ||= "redis://localhost:6379"

# Sidekiq.configure_server do |config|
#   config.redis = { url: ENV["REDIS_URL"] }

#   database_url = ENV['DATABASE_URL']
#   if database_url
#     ENV['DATABASE_URL'] = "#{database_url}?pool=10"
#     ActiveRecord::Base.establish_connection
#   end

# end


Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_URL"] }
  config.logger.level = Logger::WARN
end
