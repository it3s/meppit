require 'spec_helper'

describe Contributor do
  let(:user) { FactoryGirl.create(:user) }

  describe "contributions" do
    let(:geo_data) { FactoryGirl.create :geo_data, name: 'Test object' }

    before { Contributing.delete_all }

    describe "user with no contributions" do
      it { expect(user.contributions_count).to be 0 }
      it { expect(user.contributions.empty?).to be true }
    end

    describe "user with contributions" do
      before { Contributing.create contributor: user, contributable: contributable }

      context "user contributed only to one geo_data" do
        let(:contributable) { geo_data }
        it { expect(user.contributions_count).to be 1 }
        it { expect(user.maps_count).to be 0 }
        it { expect(user.contributions.empty?).to be false }
        it { expect(user.contributions.size).to be 1 }
        it { expect(user.contributions[0].name).to eq 'Test object' }
      end
    end
  end
end
