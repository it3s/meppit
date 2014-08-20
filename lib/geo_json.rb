module GeoJSON
  module_function

  # encode a geometry field to GeoJSON
  def encode(field, id=nil, properties={})
    return nil if field.nil?

    feature = build_feature field, id, properties
    encode_feature_collection([feature])
  end

  # convert a GeoJSON string or hash to a RGeo geometry object (or WKT string)
  def parse(geojson, opts={})
    geojson_hash = geojson.is_a?(Hash) ? geojson : JSON.parse(geojson)
    decoded_geojson = RGeo::GeoJSON.decode(geojson_hash)
    decoded_geojson = decoded_geojson.first if decoded_geojson.is_a? Enumerable
    opts.fetch(:to, :geometry) == :wkt ? decoded_geojson.geometry.as_text : decoded_geojson.geometry
  end

  def rgeo_factory
    RGeo::GeoJSON::EntityFactory.instance
  end

  def build_feature(field, id, properties)
    rgeo_factory.feature field, id, properties
  end

  # buid a geometry feature for a activerecord model
  def feature_from_model(model, field=:location)
    build_feature model.send(field), model.id, model.geojson_properties
  end

  def encode_feature_collection(features)
    features_with_geom, features_without_geom = features.partition &:geometry

    collection = RGeo::GeoJSON.encode rgeo_factory.feature_collection(features_with_geom)
    collection["features"].concat features_without_geom.map { |f| encode_empty_feature(f) }
    collection
  end

  def encode_empty_feature(feature)
    {"type"=>"Feature", "geometry"=>nil,"properties"=>feature.properties}
  end
end
