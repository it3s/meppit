require 'spec_helper'

describe Comment do
  it { expect(subject).to have_db_column :user_id }
  it { expect(subject).to have_db_column :content_id }
  it { expect(subject).to have_db_column :content_type }
  it { expect(subject).to have_db_column :comment }

  it { expect(subject).to validate_presence_of :user }
  it { expect(subject).to validate_presence_of :content }
  it { expect(subject).to validate_presence_of :comment }

  it { expect(subject).to have_db_index(:user_id) }
  it { expect(subject).to have_db_index([:content_id, :content_type]) }

  it { expect(Comment.all.explain).to match "ORDER BY created_at desc" }

end
