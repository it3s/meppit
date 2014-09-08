module BaseSerializer
  extend ActiveSupport::Concern

  def to_json(ctx=nil)
    serializable_hash.to_json
  end

  def to_xml
    serializable_hash.to_xml
  end

  def to_geojson
    geojson_feature_hash.to_json
  end

  def to_csv
    ::CSVGenerator::generate([serializable_hash])
  end

  def geojson_feature_hash
    feature = ::GeoJSON::feature_from_model object
    ::GeoJSON::encode_feature(feature)
  end
end
