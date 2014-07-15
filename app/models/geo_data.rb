class GeoData < ActiveRecord::Base
  include Contacts
  include Geometry
  include Taggable
  include Followable
  include Contributable
  include Mappable
  include Searchable

  has_many :followings, as: :followable
  has_many :followers, through: :followings

  geojson_field :location
  searchable_tags :tags
  search_field :name

  validates :name, presence: true

  def geojson_properties
    {name: name, id: id, description: description}
  end
end
