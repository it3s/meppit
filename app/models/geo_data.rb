class GeoData < ActiveRecord::Base
  include Contacts
  include Geometry
  include Taggable
  include Followable
  include Contributable
  include Mappable
  include Searchable
  include Relationships
  include Exportable
  include PublicActivity::Common

  geojson_field :location
  searchable_tags :tags
  search_fields scoped: :name, multi: [:name, :description]
  has_maps
  has_paper_trail ignore: [:id, :created_at, :updated_at]

  validates :name, presence: true

  def geojson_properties
    active_model_serializer.new(self).serializable_hash.except(:location)
  end

  def has_location?
    self.location.try(:is_empty?) == false
  end
end
