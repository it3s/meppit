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
  include Commentable

  geojson_field :location
  searchable_tags :tags
  search_fields scoped: :name, multi: [:name, :description]
  has_maps
  has_paper_trail ignore: [:id, :created_at, :updated_at]
  has_many :pictures, as: :content

  validates :name, presence: true

  def geojson_properties
    active_model_serializer.new(self).serializable_hash.except(:location)
  end
end
