class PostpicUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  process :convert => 'jpg'
  process :tags => ['post_picture']
  cloudinary_transformation :quality => 75
  
  version :standard do
    process :resize_to_fill => [600, 600, :north]
  end
  
  version :thumbnail do
    resize_to_fit(50, 50)
  end


end

  