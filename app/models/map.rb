class Map < ActiveRecord::Base
  include Contacts
  include Taggable
  include Followable
  include Contributable
  include Mappable
  include Layers
  include Searchable
  include Exportable
  include PublicActivity::Common
  include Commentable
  include Flaggable

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

  def location_geohash
    location ? location : nil
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

  def geo_data_ids
    geo_data.all.map { |data| data.id }
  end

end
