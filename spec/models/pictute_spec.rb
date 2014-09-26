require 'spec_helper'

describe Picture do
  it { expect(subject).to have_db_column :image }
  it { expect(subject).to have_db_column :description }
  it { expect(subject).to have_db_column :author_id }
  it { expect(subject).to have_db_column :content_id }
  it { expect(subject).to have_db_column :content_type }
  it { expect(subject).to validate_presence_of :author }
  it { expect(subject).to validate_presence_of :image }
  it { expect(subject).to have_db_index(:author_id) }
  it { expect(subject).to have_db_index([:content_id, :content_type]) }
end
