web: bundle exec puma -C config/puma.rb
faye: rackup faye.ru -s thin -E production
worker: bundle exec sidekiq -C config/sidekiq.yml
