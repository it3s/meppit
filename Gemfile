source 'https://rubygems.org'

ruby "2.0.0"                        # ruby version (used by heroku and rvm)

gem 'figaro'                        # easier enviroment variables
gem 'rails', '~> 4.1.1'             # rails
gem 'puma'                          # app server
gem 'foreman'                       # process supervision
gem 'pg'                            # postgresql
gem 'rgeo'                          # geometry abstraction
gem 'rgeo-geojson'                  # geojson encode/decode
gem 'activerecord-postgis-adapter'  # postgis
gem 'pg_search'                     # postgres fulltext search

gem 'coffee-rails', '~> 4.0.0'      # coffeescript
gem 'uglifier', '>= 1.3.0'          # minify
gem 'jquery-rails'                  # jquery
gem 'underscore-rails'              # underscore
gem 'sass-rails', '4.0.2'           # scss support
gem 'bourbon'                       # sass mixins and utilities
gem 'neat'                          # semantic grid system
gem 'compass-rails'                 # sass mixins and sprites generation
gem 'oily_png'                      # faster png sprite generation for compass
gem 'font-awesome-sass'             # font with svg icons
gem 'tinymce-rails'                 # tinymce wysiwyg editor
gem 'tinymce-rails-langs'           # tinymce language pack
gem "jquery-fileupload-rails"       # jquery-fielupload plugin
gem 'jquery-ui-rails'               # jqueryUI
gem 'ejs'                           # js templating for js test fixtures
gem 'meppit-map-rails', github: 'it3s/meppit-map-rails'  # our beloved map

# gem 'turbolinks'                  # speed page loading

gem 'sorcery'                       # authentication
gem 'simple_form'                   # improved forms builder
gem 'sidekiq'                       # background jobs
gem 'http_accept_language'          # get locale from http headers
gem 'carrierwave'                   # file uploads abstraction
gem 'carrierwave_backgrounder'      # delegate uploads to background jobs
gem 'mini_magick'                   # image processing for uploaders
gem 'remotipart'                    # enable ajax file uploads on remote forms
gem 'kaminari'                      # paginator
gem 'event_bus'                     # event bus for decoupling logic between models
gem 'rdiscount'                     # render markdown
gem 'paper_trail'                   # model versioning
gem 'differ'                        # build diffs
gem 'safe_yaml', require: false     # safe yaml loading


gem 'better_errors'               # better error page, and shell session when crash
gem 'binding_of_caller'           # used by better_errors

group :doc do
  gem 'sdoc', require: false
end

group :development do
  gem 'clean_logger'                # silence assets logging
  gem 'letter_opener'               # preview email in the browser
  gem 'letter_opener_web'           # web ui for letter_opener
  gem 'seedbank'                    # better fixture loading
  gem 'bullet'                      # find n+1 queries and unused eager loading
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'       # BDD
  gem 'pry'                         # better shell sessions and debug tool
  gem 'pry-rails'                   # use pry as rails console
  gem 'konacha'                     # js tests with mocha + chai
  gem 'guard-rspec', require: false # launch specs when files are modified
  gem 'i18n-tasks'                  # check for translations
end

group :test do
  gem 'shoulda-matchers'            # extra matchers for rspec
  gem 'factory_girl_rails'          # mock objects
  gem 'capybara'                    # acceptance tests
  gem 'poltergeist'                 # phantomjs driver
  gem 'database_cleaner'            # improved database cleaning for tests
  gem 'simplecov', '~> 0.7.1', require: false   # coverage report
  gem 'coveralls', require: false   # use coveralls with travisCI
end

group :production, :staging do
  gem 'mailgun_rails'               # mailgun integration for actionmailer
end
