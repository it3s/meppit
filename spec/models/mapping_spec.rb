require 'spec_helper'

describe Mapping do
  it { expect(subject).to have_db_column :map_id }
  it { expect(subject).to have_db_column :geo_data_id }
  it { expect(subject).to validate_presence_of :map  }
  it { expect(subject).to validate_presence_of :geo_data  }
  it { expect(subject).to have_db_index(:map_id) }
  it { expect(subject).to have_db_index(:geo_data_id) }
end
