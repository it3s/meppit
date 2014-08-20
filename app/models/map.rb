class Map < ActiveRecord::Base
  include Contacts
  include Taggable
  include Followable
  include Contributable
  include Mappable
  include Searchable
  include Exportable

  belongs_to :administrator, class_name: 'User'

  searchable_tags :tags
  search_fields scoped: :name, multi: [:name, :description]
  has_geo_data
  has_paper_trail ignore: [:id, :created_at, :updated_at]


  validates :name, presence: true
  validates :administrator, presence: true

  def location
    return nil if geo_data_count.zero?

    ::GeoJSON::encode_feature_collection geo_data_features
  end

  def location_geojson
    location ? location.to_json : nil
  end

  def geojson_properties
    active_model_serializer.new(self).serializable_hash.except(:location, :geo_data)
  end

  def geo_data_features
    geo_data.all.map { |data| ::GeoJSON::feature_from_model data }
  end
end
