require 'spec_helper'

describe GeoJSON do
  let(:wkt) {  "GEOMETRYCOLLECTION (POINT (-46.747319110450746 -23.56587791267138))" }
  let(:geom) { RGeo::Cartesian.simple_factory.parse_wkt wkt }
  let(:geojson) do
    {
      "type"     => "FeatureCollection",
      "features" => [
        {
          "type"       => "Feature",
          "properties" => {},
          "geometry"   => {
            "type"       => "GeometryCollection",
            "geometries" => [
              {"type" => "Point", "coordinates" => [-46.747319110450746, -23.56587791267138]}
            ]
          }
        }
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

    context "with id and properties" do
      let(:geojson) do
        {
          "type"     => "FeatureCollection",
          "features" => [
            {
              "type"       => "Feature",
              "id"         => 1,
              "properties" => {"name" => "John"},
              "geometry"   => {
                "type"       => "GeometryCollection",
                "geometries" => [
                  {"type" => "Point", "coordinates" => [-46.747319110450746, -23.56587791267138]}
                ]
              }
            }
          ]
        }
      end
      it { expect(GeoJSON::encode geom, 1, {:name => 'John'}).to eq geojson }

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

  describe "#feature_from_model" do
    let(:geo_data) { FactoryGirl.create :geo_data, location: geom }
    let(:json) { {geometry: wkt, id: geo_data.id, properties: geo_data.geojson_properties}.to_json }

    it "delegates to build_feature" do
      expect(GeoJSON).to receive(:build_feature).with(geo_data.location, geo_data.id, geo_data.geojson_properties)
      feature = GeoJSON::feature_from_model geo_data
    end
  end

  describe "#rgeo_factory" do
    it { expect(GeoJSON::rgeo_factory).to be_a_kind_of RGeo::GeoJSON::EntityFactory }
  end

  describe "#build_feature" do
    let(:geo_data) { FactoryGirl.create :geo_data, location: geom }
    let(:feature) { GeoJSON::build_feature geo_data.location, geo_data.id, {} }
    let(:json) { {geometry: wkt, id: geo_data.id, properties: {}}.to_json }

    it { expect(feature).to be_a_kind_of RGeo::GeoJSON::Feature }
    it { expect(feature.to_json).to eq json }
  end

  describe "#encode_feature_collection" do
    let(:user) { FactoryGirl.create :user, location: geom }
    let(:feature) { GeoJSON::build_feature user.location, user.id, {} }
    let(:feature_collection) { GeoJSON::encode_feature_collection [feature] }
    let(:hash) {
      {
        "type" => "FeatureCollection",
        "features" => [
          {
            "type" => "Feature",
            "geometry" => {
              "type" => "GeometryCollection",
              "geometries" => [
                {"type"=> "Point", "coordinates" => [-46.747319110450746, -23.56587791267138]}
              ]
            },
            "properties" => {},
            "id" => user.id
          }
        ]
      }
    }

    it { expect(feature_collection).to be_a_kind_of Hash }
    it { expect(feature_collection).to eq hash}
  end
end
