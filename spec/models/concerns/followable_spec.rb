require 'spec_helper'

describe Followable do
  let(:user) { FactoryGirl.create :user }
  let(:geo_data) { FactoryGirl.create :geo_data }
  let(:other_user) { FactoryGirl.create :user, name: 'John Doe' }

  describe "#followers_count" do
    it "counts followers" do
      expect(geo_data.followers_count).to eq 0

      user.followings.create followable: geo_data
      expect(geo_data.followers_count).to eq 1

      other_user.followings.create followable: geo_data
      expect(geo_data.reload.followers_count).to eq 2
    end
  end

  describe "#followers" do
    context "without followers" do
      it { expect { geo_data.followers}.to_not raise_error }
      it { expect(geo_data.followers).to eq [] }
    end

    context "with followers" do
      before { user.followings.create followable: geo_data }

      it { expect { geo_data.followers}.to_not raise_error }
      it { expect(geo_data.followers.count).to eq 1 }
      it { expect(geo_data.followers.first).to be_a_kind_of User }
      it { expect(geo_data.followers.first).to eq user }
    end
  end

  describe "destroy followings for the object when its destroyed" do
    before do
      user.followings.create followable: geo_data
      user.followings.create followable: other_user
    end

    it "destroy followings for the followable" do
      expect(user.followings.count).to eq 2
      geo_data.destroy
      expect(user.followings.count).to eq 1
      expect(user.followings.where(followable_type: 'GeoData').count).to eq 0
    end
  end
end
