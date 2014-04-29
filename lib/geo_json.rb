module GeoJson
  module_function

  # encode a geometry field to GeoJSON
  def encode(field)
    return nil if field.nil?

    rgeo_factory = RGeo::GeoJSON::EntityFactory.instance
    RGeo::GeoJSON.encode rgeo_factory.feature(field)
  end

  # convert a GeoJSON string or hash to a RGeo geometry object
  def to_geometry(geojson)
    geojson_hash = geojson.is_a?(Hash) ? geojson : JSON.parse(geojson)
    RGeo::GeoJSON.decode(geojson_hash).geometry
  end
end
