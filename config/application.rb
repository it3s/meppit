require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'active_record/connection_adapters/postgis_adapter/railtie'
require 'safe_yaml/load'

SafeYAML::OPTIONS[:default_mode] = :safe

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

class ActiveRecordOverrideRailtie < Rails::Railtie
  initializer "active_record.initialize_database.override" do |app|

    ActiveSupport.on_load(:active_record) do
      if url = ENV['DATABASE_URL']
        ActiveRecord::Base.connection_pool.disconnect!
        parsed_url = URI.parse(url)
        config =  {
          adapter:             'postgis',
          host:                parsed_url.host,
          encoding:            'unicode',
          database:            parsed_url.path.split("/")[-1],
          port:                parsed_url.port,
          username:            parsed_url.user,
          password:            parsed_url.password
        }
        establish_connection(config)
      end
    end
  end
end

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
