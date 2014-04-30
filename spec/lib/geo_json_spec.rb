require 'spec_helper'

describe GeoJSON do
  let(:wkt) {  "GEOMETRYCOLLECTION (POINT (-23.56587791267138 -46.747319110450746))" }
  let(:geom) { RGeo::Cartesian.simple_factory.parse_wkt wkt }
  let(:geojson) do
    {
      "type"     => "FeatureCollection",
      "features" => [
        "type"   => "Feature",
        "geometry" => {
          "type"       => "GeometryCollection",
          "geometries" => [
            {
              "type"        => "Point",
              "coordinates" => [-23.56587791267138, -46.747319110450746]
            }
          ]
        },
        "properties" => {}
      ]
    }
  end

  describe "#encode" do
    it "returns nil when geometry is nil" do
      expect(GeoJSON::encode nil).to be_nil
    end

    it "encodes properly to geojson from geometry" do
      expect(GeoJSON::encode geom).to eq geojson
    end
  end

  describe "#parse" do
    it "parses geojson hash to geometry" do
      expect(GeoJSON::parse(geojson).as_text).to eq geom.as_text
    end

    it "parses geojson string to geometry" do
      expect(GeoJSON::parse(geojson.to_json).as_text).to eq geom.as_text
    end

    it "generates same geojson when parse and encode" do
      expect(GeoJSON::encode(GeoJSON::parse(geojson))).to eq geojson
    end

    it "parses to wkt format" do
      expect(GeoJSON::parse geojson, :to => :wkt).to eq wkt
    end

  end
end
