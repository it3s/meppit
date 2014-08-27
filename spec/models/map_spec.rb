require 'spec_helper'

describe Map do
  it { expect(subject).to have_db_column :name }
  it { expect(subject).to have_db_column :description }
  it { expect(subject).to have_db_column :tags }
  it { expect(subject).to have_db_column :contacts }
  it { expect(subject).to have_db_column :administrator_id }
  it { expect(subject).to have_db_column :additional_info }
  it { expect(subject).to validate_presence_of :name }
  it { expect(subject).to validate_presence_of :administrator }
  it { expect(subject).to have_db_index(:tags) }
  it { expect(subject).to have_db_index(:administrator_id) }

  it 'contacts is a hstore and accepts map in hash format' do
    map = FactoryGirl.build(:map)
    map.contacts = {'test' => 'ok', 'address' => 'av paulista, 800, SP'}
    expect(map.save).to be true
    expect(Map.find_by(:id => map.id).contacts).to eq({'test' => 'ok', 'address' => 'av paulista, 800, SP'})
  end

  describe "mappings" do
    let(:map) { FactoryGirl.create :map }
    let(:geo_data) { FactoryGirl.create :geo_data }

    before { map.mappings.create geo_data: geo_data }

    it { expect(map.geo_data_count).to eq 1 }
    it { expect(map.geo_data.first).to eq geo_data }
  end

  describe "mappings" do
    let(:map) { FactoryGirl.create :map }

    let(:geom1) { RGeo::Cartesian.simple_factory.parse_wkt "GEOMETRYCOLLECTION (POINT (-10.000 -10.000))" }
    let(:geom2) { RGeo::Cartesian.simple_factory.parse_wkt "GEOMETRYCOLLECTION (POINT (-10.001 -10.001))" }

    let(:data1) { FactoryGirl.create :geo_data, name: 'Data 1', location: geom1 }
    let(:data2) { FactoryGirl.create :geo_data, name: 'Data 2', location: geom2 }

    let(:geojson) {
      {
        "type" => "FeatureCollection",
        "features" => [
          {
            "type" => "Feature",
            "geometry" => {
              "type" => "GeometryCollection",
              "geometries" => [{"type"=>"Point", "coordinates"=>[-10.0, -10.0]}]
            },
            "properties" => data1.geojson_properties.stringify_keys,
            "id" => data1.id
          },
          {
            "type" => "Feature",
            "geometry" => {
              "type" => "GeometryCollection",
              "geometries" => [{"type"=>"Point", "coordinates"=>[-10.001, -10.001]}]
            },
            "properties" => data2.geojson_properties.stringify_keys,
            "id" => data2.id
          }
        ]
      }
    }

    before {
      map.mappings.create(geo_data: data1)
      map.mappings.create(geo_data: data2)
    }

    describe "#geo_data_count" do
      it { expect(map.geo_data_count).to eq 2 }
    end

    describe "#geo_data_features" do
      it { expect(map.geo_data_features).to be_a_kind_of Array }
      it { expect(map.geo_data_features.count).to eq 2 }
      it { expect(map.geo_data_features.first).to be_a_kind_of RGeo::GeoJSON::Feature }
    end

    describe "#geo_data_ids" do
      it { expect(map.geo_data_ids).to eq [data1.id, data2.id] }
    end

    describe "#location" do
      it "returns nil if geo_data_count is zero" do
        allow(map).to receive(:geo_data_count).and_return 0
        expect(map.location).to be nil
      end

      it "encode a feature collection" do
        expect(::GeoJSON).to receive(:encode_feature_collection).with map.geo_data_features
        map.location
      end

      it { expect(map.location.keys).to eq geojson.keys }
      it { expect(map.location["features"].size).to eq 2 }
    end

    describe "#location_geojson" do
      it "returns nil when location is nil" do
        allow(map).to receive(:location).and_return nil
        expect(map.location_geojson).to be nil
      end

      it { expect(map.location_geojson).to include geojson["features"][0].to_json }
      it { expect(map.location_geojson).to include geojson["features"][1].to_json }
    end

    describe "#add_geo_data" do
      before { map.mappings.destroy_all }

      it "adds a new geo_data mapping" do
        mapping = map.add_geo_data data1
        expect(mapping.id).to_not be nil
        expect(map.mappings.count).to eq 1
        expect(map.geo_data.first).to eq data1
      end

      it "does not add duplicated mapping" do
        map.add_geo_data data1
        mapping = map.add_geo_data data1
        expect(mapping.id).to be nil
        expect(map.mappings.count).to eq 1
      end
    end
  end

  describe ".search_by_name" do
    before do
      ['Open Data Orgs', 'ONGS', 'Data Centers', 'bla', 'ble'].each { |n| FactoryGirl.create :map, name: n }
    end

    it { expect(Map.search_by_name('op'  ).map(&:name)).to eq ['Open Data Orgs'] }
    it { expect(Map.search_by_name('on'  ).map(&:name)).to eq ['ONGS'] }
    it { expect(Map.search_by_name('data').map(&:name)).to eq ['Open Data Orgs', 'Data Centers'] }
    it { expect(Map.search_by_name('bl'  ).map(&:name)).to eq ['bla', 'ble'] }
  end

  describe "versioning", versioning: true do
    let(:map) { FactoryGirl.create :map, name: 'name' }

    it { expect(map).to be_versioned }

    it "save versions" do
      expect(map.versions.count).to eq 1
      map.update_attributes! name: 'new name'
      expect(map.versions.count).to eq 2
      expect(map.versions.where_object(name: 'name').any?).to be true
    end
  end
end
