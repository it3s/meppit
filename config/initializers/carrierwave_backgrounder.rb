CarrierWave::Backgrounder.configure do |c|
  c.backend :sidekiq, queue: :uploads
end
