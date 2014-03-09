if Rails.env.test? || Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => Rails.application.config.SECRETS[:s3_key],
      :aws_secret_access_key  => Rails.application.config.SECRETS[:s3_secret],
    }
    config.asset_host     = "https://s3.amazonaws.com/#{Rails.application.config.SECRETS[:s3_bucket]}"
    config.fog_directory  = Rails.application.config.SECRETS[:s3_bucket]
  end
end
