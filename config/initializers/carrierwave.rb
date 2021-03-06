if Rails.env.test? || Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV["S3_KEY"],
      :aws_secret_access_key  => ENV["S3_SECRET"],
    }
    # config.asset_host     = "https://s3.amazonaws.com/#{ENV["S3_BUCKET"]}"
    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.fog_directory  = ENV["S3_BUCKET"]
    # config.fog_public = false
    config.storage = :fog
  end
end
