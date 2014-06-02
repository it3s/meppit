class GeoData < ActiveRecord::Base
  include Contacts
  include Geometry
  include Taggable

  geojson_field :location
  searchable_tags :tags

  validates :name, presence: true

  def geojson_properties
    {name: name, id: id, description: description}
  end
end
