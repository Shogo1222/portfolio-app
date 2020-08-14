# frozen_string_literal: true

require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
if Rails.env.production?
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_S3'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY_S3'],
      region: ENV['REGION'],
      path_style: true
    }
    config.storage :fog
    config.asset_host = ENV['S3_END_POINT']
    config.fog_provider = 'fog/aws'
    config.fog_directory  = ENV['S3_NAME']
    config.cache_storage = :fog
  else
  config.asset_host = ENV['LOCAL_HOST']
  config.storage :file
  config.enable_processing = false if Rails.env.test?
  end
end
