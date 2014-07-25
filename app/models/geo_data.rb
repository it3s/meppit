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
  search_fields scoped: :name, multi: [:name, :description]
  has_maps
  has_paper_trail ignore: [:updated_at]

  validates :name, presence: true

  def geojson_properties
    {name: name, id: id, description: description}
  end
end
