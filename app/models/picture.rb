class Picture < ActiveRecord::Base
  mount_uploader :image, PictureUploader
  process_in_background :image

  validates :picture, presence: true
  validates :author,  presence: true

end
