class LargeCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process :resize_to_limit => [665, 375]

  def store_dir
  	"tmp"
  end
end