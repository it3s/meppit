require 'spec_helper'

describe Mapping do
  it { expect(subject).to have_db_column :map_id }
  it { expect(subject).to have_db_column :geo_data_id }
  it { expect(subject).to validate_presence_of :map  }
  it { expect(subject).to validate_presence_of :geo_data  }
  it { expect(subject).to have_db_index(:map_id) }
  it { expect(subject).to have_db_index(:geo_data_id) }

  let(:map) { FactoryGirl.create :map }
  let(:geo_data) { FactoryGirl.create :geo_data }

  it "does not allow duplicated mapping" do
    mapping = Mapping.create map: map, geo_data: geo_data
    expect(mapping.id).to_not be nil
    expect(Mapping.count).to eq 1

    mapping = Mapping.create map: map, geo_data: geo_data
    expect(mapping.id).to be nil
    expect(Mapping.count).to eq 1
    expect(mapping.errors.messages[:geo_data].first).to eq I18n.t('activerecord.errors.messages.taken')
  end
end
