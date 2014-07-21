class GeoData < ActiveRecord::Base
  include Contacts
  include Geometry
  include Taggable
  include Followable
  include Contributable
  include Mappable
  include Searchable

  geojson_field :location
  searchable_tags :tags
  search_fields scoped: :name
  has_maps

  validates :name, presence: true

  def geojson_properties
    {name: name, id: id, description: description}
  end
end
