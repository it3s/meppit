require 'spec_helper'

describe GeoData do
  it { expect(subject).to have_db_column :name }
  it { expect(subject).to have_db_column :description }
  it { expect(subject).to have_db_column :tags }
  it { expect(subject).to have_db_column :contacts }
  it { expect(subject).to have_db_column :location }
  it { expect(subject).to have_db_column :additional_info }
  it { expect(subject).to validate_presence_of :name }
  it { expect(subject).to have_db_index(:location) }
  it { expect(subject).to have_db_index(:tags) }

  it 'contacts is a hstore and accepts data in hash format' do
    data = FactoryGirl.build(:geo_data)
    data.contacts = {'test' => 'ok', 'address' => 'av paulista, 800, SP'}
    expect(data.save).to be true
    expect(GeoData.find_by(:id => data.id).contacts).to eq({'test' => 'ok', 'address' => 'av paulista, 800, SP'})
  end

  describe "geojson properties" do
    let(:data) { FactoryGirl.create(:geo_data) }

    it { expect(data.geojson_properties).to have_key(:id) }
    it { expect(data.geojson_properties).to have_key(:name) }
  end

  describe "mappings" do
    let(:geo_data) { FactoryGirl.create :geo_data }
    let(:map) { FactoryGirl.create :map }

    before { geo_data.mappings.create map: map }

    it { expect(geo_data.maps_count).to eq 1 }
    it { expect(geo_data.maps.first).to eq map }

    describe "#add_map" do
      before { geo_data.mappings.destroy_all }
      it "creates new mapping" do
        mapping = geo_data.add_map map
        expect(mapping.id).to_not be nil
        expect(geo_data.mappings.count).to eq 1
        expect(geo_data.maps.first).to eq map
      end
      it "does not duplicate a mapping" do
        geo_data.add_map map
        mapping = geo_data.add_map map
        expect(mapping.id).to be nil
        expect(geo_data.mappings.count).to eq 1
      end
    end

    it "destroys associated mappings when deleted" do
      expect(Mapping.where(geo_data: geo_data).count).to eq 1
      geo_data.destroy
      expect(Mapping.where(geo_data: geo_data).count).to eq 0
    end
  end

  describe ".search_by_name" do
    before do
      ['OKFN', 'OKFN-br', 'bla', 'ble'].each { |n| FactoryGirl.create :geo_data, name: n }
    end

    it { expect(GeoData.search_by_name('okf' ).map(&:name)).to eq ['OKFN-br', 'OKFN'] }
    it { expect(GeoData.search_by_name('br'  ).map(&:name)).to eq ['OKFN-br'] }
    it { expect(GeoData.search_by_name('bl'  ).map(&:name)).to eq ['bla', 'ble'] }
  end

  describe "versioning", versioning: true do
    let(:geo_data) { FactoryGirl.create :geo_data, name: 'name' }

    it { expect(geo_data).to be_versioned }

    it "save versions" do
      expect(geo_data.versions.count).to eq 1
      geo_data.update_attributes! name: 'new name'
      expect(geo_data.versions.count).to eq 2
      expect(geo_data.versions.where_object(name: 'name').any?).to be true
    end
  end

  describe "Relationships" do
    let(:geo_data) { FactoryGirl.create :geo_data }
    let(:other)    { FactoryGirl.create :geo_data }
    let(:another)  { FactoryGirl.create :geo_data }
    let!(:relation) { Relation.create related_ids: [geo_data.id, other.id], rel_type: 'partnership', direction: 'dir' }

    it "on destroy remove all relations" do
      expect(Relation.find_related(geo_data.id).count).to eq 1
      geo_data.destroy
      expect(Relation.find_related(geo_data.id).count).to eq 0
    end

    describe "relations_values" do
      it { expect(geo_data.relations_values).to be_a_kind_of Array }
      it { expect(geo_data.relations_values.first).to be_a_kind_of Hash }
      it { expect(geo_data.relations_values.first).to eq({
          id:       relation.id,
          target:   {id: other.id, name: other.name },
          type:     "partnership_dir",
          metadata: {},
        })
      }
      it { expect(geo_data.relations_values(splitted_type: true).first).to eq({
          id:        relation.id,
          target:    {id: other.id, name: other.name },
          rel_type:  "partnership",
          direction: "dir",
          metadata:  {},
        })
      }
    end

    describe "save_relations_from_attributes" do
      before {
        Relation.destroy_all
        @rel1 = Relation.create related_ids: [geo_data.id, geo_data.id], rel_type: 'partnership', direction: 'dir'
        @rel2 = Relation.create related_ids: [geo_data.id, other.id], rel_type: 'partnership', direction: 'dir'
        @attrs = [
          OpenStruct.new(id: @rel2.id, target: other.id, direction: 'dir', rel_type: 'ownership', metadata: {}),
          OpenStruct.new(id: nil, target: another.id, direction: 'dir', rel_type: 'partnership', metadata: {}),
        ]
      }

      it "removes rel1, updates rel2, and add relation to another.id" do
        expect(geo_data.send(:get_all_relateds).keys).to eq [geo_data.id, other.id]
        geo_data.relations_attributes = @attrs
        geo_data.save_relations_from_attributes
        geo_data.relations.reload

        expect(geo_data.send(:get_all_relateds).keys).to eq [other.id, another.id]
        expect(@rel2.reload.rel_type).to eq 'ownership'
      end
    end
  end
end
