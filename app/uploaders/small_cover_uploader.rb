class SmallCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process :resize_to_limit => [166, 236]  

  def store_dir
  	"tmp"
  end
end