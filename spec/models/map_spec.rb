require 'spec_helper'

describe Map do
  it { expect(subject).to have_db_column :name }
  it { expect(subject).to have_db_column :description }
  it { expect(subject).to have_db_column :tags }
  it { expect(subject).to have_db_column :contacts }
  it { expect(subject).to have_db_column :administrator_id }
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

    it { expect(map.data_count).to eq 1 }
    it { expect(map.geo_data.first).to eq geo_data }
  end

end
