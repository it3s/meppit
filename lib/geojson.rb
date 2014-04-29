module Geojson
  module_function

  # encode a geometry field to GeoJSON
  def encode(field)
    return nil if field.nil?

    rgeo_factory = RGeo::GeoJSON::EntityFactory.instance
    RGeo::GeoJSON.encode rgeo_factory.feature(field)
  end

  # convert a GeoJSON string or hash to a RGeo geometry object (or WKT string)
  def parse(geojson, opts={})
    geojson_hash = geojson.is_a?(Hash) ? geojson : JSON.parse(geojson)
    decoded_geojson = RGeo::GeoJSON.decode(geojson_hash)
    opts.fetch(:to, :geometry) == :wkt ? decoded_geojson.geometry.as_text : decoded_geojson.geometry
  end
end

GeoJSON = Geojson
