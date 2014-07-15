class GeoData < ActiveRecord::Base
  include Contacts
  include Geometry
  include Taggable
  include Followable
  include Contributable
  include Searchable

  has_many :followings, as: :followable
  has_many :followers, through: :followings

  has_many :mappings
  has_many :maps, through: :mappings

  geojson_field :location
  searchable_tags :tags
  search_field :name

  validates :name, presence: true


  def geojson_properties
    {name: name, id: id, description: description}
  end

  def maps_count
    maps.count
  end

  def add_to_map(map)
    mappings.create map: map
  end
end
