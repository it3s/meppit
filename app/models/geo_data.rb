class GeoData < ActiveRecord::Base
  include Contacts
  include Geometry
  include Taggable
  include Followable
  include Contributable

  geojson_field :location
  searchable_tags :tags

  validates :name, presence: true

  def geojson_properties
    {name: name, id: id, description: description}
  end

  def maps_count
    #TODO refactor to concern
    0
  end
end
