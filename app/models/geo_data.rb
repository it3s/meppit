class GeoData < ActiveRecord::Base
  include PgSearch
  include Contacts
  include Geometry
  include Taggable
  include Followable
  include Contributable

  has_many :followings, as: :followable
  has_many :followers, through: :followings

  has_many :mappings
  has_many :maps, through: :mappings

  geojson_field :location
  searchable_tags :tags

  validates :name, presence: true

  pg_search_scope :search_by_name, against: :name, using: {
    tsearch: {prefix: true},
    trigram: {threshold: 0.2},
  }

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
