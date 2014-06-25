require 'spec_helper'

describe Follower do
  let(:user) { FactoryGirl.create :user }
  let(:other_user) { FactoryGirl.create :user, name: 'John Doe' }
  let(:geo_data) { FactoryGirl.create :geo_data }

  describe "has_many followings" do
    it { expect {user.followings}.to_not raise_error }
    it { expect(user.followings).to eq [] }

    context "with followings" do
      before { user.followings.create followable: geo_data }

      it { expect(user.followings.count).to be 1 }
      it { expect(user.followings.first).to be_a_kind_of Following }
      it { expect(user.followings.first.followable).to eq geo_data }
    end
  end

  describe "#following" do
    before { user.followings.create followable: geo_data }

    it { expect {user.following}.to_not raise_error }
    it { expect(user.following.count).to be 1 }
    it { expect(user.following.first).to be_a_kind_of GeoData }
    it { expect(user.following.first).to eq geo_data }
  end

  describe "destroy followings when follower is destroyed" do
    before { user.followings.create followable: geo_data }

    it "destroy associated followers" do
      expect(Following.where(follower_id: user.id).count).to eq 1
      user.destroy
      expect(Following.where(follower_id: user.id).count).to eq 0
    end
  end

  describe "#follow?" do
    context "user is no following content" do
      it { expect(user.follow? geo_data).to be false }
    end

    context "user is following content" do
      before { user.followings.create followable: geo_data }
      it { expect(user.follow? geo_data).to be true }
    end
  end

  describe "#follow" do
    before { Following.delete_all }

    it "adds user as follower" do
      expect(geo_data.followers_count).to be 0
      expect(user.follow(geo_data)).to be true
      expect(geo_data.followers_count).to be 1
      expect(geo_data.followers.first).to eq user
    end
  end

  describe "#unfollow" do
    before do
      Following.create followable: geo_data, follower: user
      Following.create followable: geo_data, follower: other_user
    end

    it "adds user as follower" do
      expect(geo_data.followers_count).to be 2
      expect(user.unfollow(geo_data)).to_not be nil
      expect(geo_data.followers_count).to be 1
      expect(geo_data.followers.first.id).to be other_user.id
    end
  end
end
