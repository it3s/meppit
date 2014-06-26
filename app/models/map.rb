class Map < ActiveRecord::Base
  include Contacts
  include Geometry
  include Taggable
  include Followable
  include Contributable

  has_many :followings, :as => :followable
  has_many :followers, :through => :followings

  geojson_field :location
  searchable_tags :tags

  validates :name, presence: true

  def geojson_properties
    {name: name, id: id, description: description}
  end

  def data_count
    #TODO refactor to concern
    0
  end
end
