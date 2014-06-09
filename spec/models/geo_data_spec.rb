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
    expect(data.save).to be_true
    expect(GeoData.find_by(:id => data.id).contacts).to eq({'test' => 'ok', 'address' => 'av paulista, 800, SP'})
  end

  describe "geojson properties" do
    it "should have id" do
      expect(user.geojson_properties).to have_key(:id)
      expect(user.geojson_properties).to have_key(:name)
    end
  end
end