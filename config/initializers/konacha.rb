Capybara.register_driver :slow_poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, timeout: 2.minutes)
end if defined?(Capybara)

# https://github.com/jfirebaugh/konacha/issues/123
Capybara.server do |app, port|
  if Konacha.mode == :runner
    require 'rack/handler/thin'
    Rack::Handler::Thin.run(app, Port: port)
  else
    Capybara.run_default_server(app, port)
  end
end if defined?(Capybara)

Konacha.configure do |config|
  require 'capybara/poltergeist'

  config.spec_dir     = "spec/javascripts"
  config.spec_matcher = /_spec\.|_test\./
  config.stylesheets  = %w(application)

  config.driver       = :slow_poltergeist
  # config.driver      = :selenium
end if defined?(Konacha)
