require 'spec_helper'

describe Notification do
  let(:user) { FactoryGirl.create :user }
  let(:other_user) { FactoryGirl.create :user, name: 'other' }
  let(:geo_data) { FactoryGirl.create :geo_data }
  let(:activity) { geo_data.create_activity :update, owner: other_user, parameters: {changes: {"name"=>["", geo_data.name]}} }

  it { expect(subject).to have_db_column :activity_id }
  it { expect(subject).to have_db_column :user_id }
  it { expect(subject).to have_db_column :status }
  it { expect(subject).to validate_presence_of :activity }
  it { expect(subject).to validate_presence_of :user }
  it { expect(subject).to have_db_index(:user_id) }

  describe "default status" do
    let(:notification) { Notification.create activity: activity, user: user }

    it { expect(notification.status).to eq 'unread' }
  end

  describe ".build_notifications" do
    it "delegates to NotificationWorker" do
      expect(NotificationWorker).to receive(:perform_async).with activity.id
      Notification.build_notifications activity
    end
  end

  describe "#rt_notify" do
    let!(:notification) { Notification.create user: user, activity: activity }

    it "publishes message to FayeClient" do
      expect(FayeClient).to receive(:publish).with "/notifications/#{user.id}", {count: 1}
      notification.rt_notify
    end
  end
end
