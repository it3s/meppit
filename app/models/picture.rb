class Picture < ActiveRecord::Base
  mount_uploader :image, PictureUploader
  process_in_background :image

  belongs_to :object, polymorphic: true
  belongs_to :author, class_name: 'User'


  validates :image, presence: true
  validates :author,  presence: true

end
