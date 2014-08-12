if Rails.env.test? || Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV.fetch("S3_KEY", ""),
      :aws_secret_access_key  => ENV.fetch("S3_SECRET", ""),
    }
    config.asset_host     = "https://s3.amazonaws.com/#{ENV["S3_BUCKET"]}"
    config.fog_directory  = ENV["S3_BUCKET"]
  end
end
