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

  describe "contributors" do
    let(:user) { FactoryGirl.create :user, name: 'Bob' }
    let(:data) { FactoryGirl.create :geo_data }

    before { Contributing.delete_all }

    describe "data with no contributors" do
      it { expect(data.contributors_count).to be 0 }
      it { expect(data.contributors.empty?).to be true }
    end

    describe "data with contributors" do

      describe "one user contributed to data" do
        before { Contributing.create contributor: user, contributable: data }

        it { expect(data.contributors_count).to be 1 }
        it { expect(data.contributors.empty?).to be false }
        it { expect(data.contributors.size).to be 1 }
        it { expect(data.contributors[0].name).to eq 'Bob' }
      end
    end
  end
end
