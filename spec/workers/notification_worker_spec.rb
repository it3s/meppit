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

    it "calls rt_notify on the created notification" do
      notification = Notification.create activity: activity, user: user
      allow(Notification).to receive(:create).and_return notification
      expect(notification).to receive(:rt_notify)
      worker.perform activity.id
    end
  end

end
