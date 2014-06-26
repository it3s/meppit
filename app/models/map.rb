class Map < ActiveRecord::Base
  include Contacts
  include Taggable
  include Followable
  include Contributable

  has_many :followings, :as => :followable
  has_many :followers, :through => :followings

  searchable_tags :tags

  validates :name, presence: true

  def data_count
    #TODO refactor to concern
    0
  end
end
