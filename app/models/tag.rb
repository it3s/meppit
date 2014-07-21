class Tag < ActiveRecord::Base
  # used for indexing and search of tag-like array fields
  include Searchable

  validates :tag, uniqueness: true

  before_save :downcase

  search_fields scoped: :tag

  def downcase
    tag.downcase!
  end

  def self.build(tag)
    self.new tag: tag.downcase
  end

  def self.search(term)
    search_by_tag term
  end
end
