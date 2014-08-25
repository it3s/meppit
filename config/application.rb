require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'active_record/connection_adapters/postgis_adapter/railtie'

# explicit require to avoid patching default YAML
require 'safe_yaml/load'
SafeYAML::OPTIONS[:default_mode] = :safe

require 'csv'
require 'net/http'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Meppit
  class Application < Rails::Application
    # Set Time.zone default and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Brasilia'
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/*.{rb,yml}').to_s]
    # config.i18n.default_locale = :'pt-BR'
    I18n.enforce_available_locales = false  # stop annoying messages
  end
end
