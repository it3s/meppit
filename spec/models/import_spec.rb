require 'spec_helper'

describe Import do
  it { expect(subject).to validate_presence_of :user }
  it { expect(subject).to validate_presence_of :source }

  let(:import) { FactoryGirl.create :import }

  describe "#parse_source" do
    let(:parsed) { import.parse_source }

    it { expect(parsed).to be_a_kind_of Array }
    it { expect(parsed.first).to be_a_kind_of OpenStruct }
    it { expect(parsed.first.row).to_not be nil }
    it { expect(parsed.first.data).to be_a_kind_of Hash }
    it { expect(parsed.first.data.keys).to match_array [:name, :description, :tags, :contacts, :additional_info] }
  end

  describe ".csv_headers" do
    it { expect(Import.csv_headers).to be_a_kind_of Array }
    it { expect(Import.csv_headers).to include('name') }
    it { expect(Import.csv_headers).to include('description') }
    it { expect(Import.csv_headers).to include('tags') }
    it { expect(Import.csv_headers).to include('additional_info') }
  end

  describe "#filename" do
    it { expect(import.filename).to eq 'import_test.csv' }
  end

  describe "#load_to_map!" do
    let(:map) { FactoryGirl.create :map }

    before { GeoData.destroy_all }

    it "creates geo_data from the csv source" do
      expect(GeoData.count).to eq 0
      import.load_to_map! map.id
      expect(GeoData.count).to eq 2
      expect(import.imported_data_ids.size).to eq 2
    end

    it "set imported to true" do
      expect(import.imported).to be false
      import.load_to_map! map.id
      expect(import.imported).to be true
    end

    it "associates import to map" do
      import.load_to_map! map.id
      expect(import.map).to eq map
    end
  end

  describe "user#imports" do
    let!(:user)   { FactoryGirl.create :user }
    let!(:import) { FactoryGirl.create :import, user: user }

    it { expect(user.imports.first).to eq import }
  end
end
