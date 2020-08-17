# frozen_string_literal: true

class ImageUploader < CarrierWave::Uploader::Base
  if Rails.env.production? || Rails.env.staging?
    storage :fog
  else
    storage :file
  end
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w[jpg jpeg gif png]
  end

  def filename
    "#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.jpg" if original_filename.present?
  end
end
