Capybara.register_driver :slow_poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, timeout: 2.minutes)
end

Konacha.configure do |config|
  require 'capybara/poltergeist'

  config.spec_dir     = "spec/javascripts"
  config.spec_matcher = /_spec\.|_test\./
  config.stylesheets  = %w(application)

  config.driver       = :slow_poltergeist
  # config.driver      = :selenium
end if defined?(Konacha)
