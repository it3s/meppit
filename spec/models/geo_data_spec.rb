require 'spec_helper'

describe GeoData do
  it { expect(subject).to have_db_column :name }
  it { expect(subject).to have_db_column :description }
  it { expect(subject).to have_db_column :tags }
  it { expect(subject).to have_db_column :contacts }
  it { expect(subject).to have_db_column :location }
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
  end
end
