require 'spec_helper'

describe Notification do
  it { expect(subject).to have_db_column :activity_id }
  it { expect(subject).to have_db_column :user_id }
  it { expect(subject).to have_db_column :status }
  it { expect(subject).to validate_presence_of :activity }
  it { expect(subject).to validate_presence_of :user }
  it { expect(subject).to have_db_index(:user_id) }

  describe "default status" do
    let(:geo_data) { FactoryGirl.create :geo_data }
    let(:user) { FactoryGirl.create :user }

    let(:activity) { geo_data.create_activity :create, owner: user }
    let(:notification) { Notification.create activity: activity, user: user }

    it { expect(notification.status).to eq 'unread' }
  end
end
