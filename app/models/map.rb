class Map < ActiveRecord::Base
  include Contacts
  include Taggable
  include Followable
  include Contributable

  has_many :followings, :as => :followable
  has_many :followers, :through => :followings

  belongs_to :administrator, class_name: 'User'

  searchable_tags :tags

  validates :name, presence: true
  validates :administrator, presence: true

  def data_count
    #TODO refactor to concern
    0
  end

  def location
    # TODO: get aggregated location from associated geo_data
    nil
  end
end
