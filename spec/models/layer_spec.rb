require 'spec_helper'

describe Layer do
  it { expect(subject).to have_db_column :name }
  it { expect(subject).to have_db_column :position }
  it { expect(subject).to have_db_column :visible }
  it { expect(subject).to have_db_column :fill_color }
  it { expect(subject).to have_db_column :stroke_color }
  it { expect(subject).to have_db_column :rule }
  it { expect(subject).to have_db_column :map_id }
  it { expect(subject).to validate_presence_of :map_id }
  it { expect(subject).to validate_presence_of :name }
  it { expect(subject).to validate_presence_of :rule }
  it { expect(subject).to have_db_index(:map_id) }
end
