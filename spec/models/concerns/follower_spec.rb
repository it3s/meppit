require 'spec_helper'

describe Follower do
  let(:user) { FactoryGirl.create :user }

  describe "has_many followings" do
    it { expect {user.followings}.to_not raise_error }
    it { expect(user.followings).to eq [] }

    context "with followings" do
      let(:geo_data) { FactoryGirl.create :geo_data }
      before { user.followings.create followable: geo_data }

      it { expect(user.followings.count).to be 1 }
      it { expect(user.followings.first).to be_a_kind_of Following }
      it { expect(user.followings.first.followable).to eq geo_data }
    end
  end

  describe "#followed_objects" do
    let(:geo_data) { FactoryGirl.create :geo_data }
    before { user.followings.create followable: geo_data }

    it { expect {user.followed_objects}.to_not raise_error }
    it { expect(user.followed_objects.count).to be 1 }
    it { expect(user.followed_objects.first).to be_a_kind_of GeoData }
    it { expect(user.followed_objects.first).to eq geo_data }
  end

  describe "destroy followings when follower is destroyed" do
    let(:geo_data) { FactoryGirl.create :geo_data }
    before { user.followings.create followable: geo_data }

    it "destroy associated followers" do
      expect(Following.where(follower_id: user.id).count).to eq 1
      user.destroy
      expect(Following.where(follower_id: user.id).count).to eq 0
    end
  end

  describe "#follow?" do
    let(:geo_data) { FactoryGirl.create :geo_data }

    context "user is no following content" do
      it { expect(user.follow? geo_data).to be_false }
    end

    context "user is following content" do
      before { user.followings.create followable: geo_data }
      it { expect(user.follow? geo_data).to be_true }
    end

  end
end
