class Import < ActiveRecord::Base
  mount_uploader :source, ImportUploader
  process_in_background :source

  belongs_to :user

  validates :source, presence: true
  validates :user,   presence: true
end
