class Tag < ActiveRecord::Base
  # used for indexing and search of tag-like array fields
  include PgSearch

  validates :tag, uniqueness: true

  before_save :downcase

  pg_search_scope :search, against: :tag, using: [:tsearch, :trigram, :dmetaphone]

  def downcase
    tag.downcase!
  end

  def self.build(tag)
    self.new tag: tag.downcase
  end
end
