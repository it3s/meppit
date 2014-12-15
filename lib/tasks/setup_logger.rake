#Sets up logging - should only be called from other rake tasks
task setup_logger: :environment do
  logger           = Logger.new(STDOUT)
  logger.level     = Logger::INFO
  logger.formatter = proc do |severity, datetime, progname, msg|
    "#{msg}"
  end
  Rails.logger     = logger
end
