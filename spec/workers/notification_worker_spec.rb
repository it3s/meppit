require 'spec_helper'

describe NotificationWorker do
  let(:worker) { NotificationWorker.new }

  let(:user) { FactoryGirl.create :user }
  let(:other_user) { FactoryGirl.create :user, name: 'other' }
  let(:activity) { other_user.create_activity :update, owner: other_user }

  before { user.follow other_user }

  describe "users_to_receive_notification" do
    it { expect(worker.send :users_to_receive_notification, activity).to eq [user.id] }
  end

  describe "perform" do
    before { Notification.destroy_all }

    it "creates notification" do
      expect(Notification.count).to eq 0
      worker.perform activity.id
      expect(Notification.count).to eq 1
    end
  end
end
