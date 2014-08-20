class MapSerializer  < ActiveModel::Serializer
  include BaseSerializer

  attributes :id, :name, :description, :additional_info, :contacts, :tags,
             :created_at, :updated_at

  has_many :geo_data

  def to_geojson
    feature = ::GeoJSON.build_feature nil, object.id, object.geojson_properties
    encoded = ::GeoJSON::encode_feature(feature)
    encoded["properties"]["geo_data"] = object.location
    encoded.to_json
  end
end
