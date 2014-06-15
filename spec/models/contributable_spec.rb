require 'spec_helper'

describe Contributable do
  let(:user) { FactoryGirl.create :user, name: 'Bob' }
  let(:data) { FactoryGirl.create :geo_data }

  describe "contributors" do
    before { Contributing.delete_all }

    describe "data with no contributors" do
      it { expect(data.contributors_count).to be 0 }
      it { expect(data.contributors.empty?).to be true }
    end

    describe "data with contributors" do

      describe "one user contributed to data" do
        before { Contributing.create contributor: user, contributable: data }

        it { expect(data.contributors_count).to be 1 }
        it { expect(data.contributors.empty?).to be false }
        it { expect(data.contributors.size).to be 1 }
        it { expect(data.contributors[0].name).to eq 'Bob' }
      end
    end
  end

  describe "#add_contributor" do
    before { Contributing.delete_all }

    it "adds user as contributor" do
      expect(data.contributors_count).to be 0
      expect(data.contributors.empty?).to be true
      expect(data.add_contributor(user)).to be true
      expect(data.contributors(true).size).to be 1
      expect(data.contributors_count).to be 1
      expect(data.contributors[0].name).to eq 'Bob'
    end
  end
end
