class Tag < ActiveRecord::Base
  before_save :downcase

  validates :tag, uniqueness: true

  def downcase
    tag.downcase!
  end
end
