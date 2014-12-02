require 'spec_helper'

describe Featurable do
  let(:data) { FactoryGirl.create :geo_data }

  describe "set/uset as featured" do
    before { Featured.destroy_all }

    it "set as featured" do
      expect(Featured.count).to eq 0
      expect(data.featured?).to eq false
      data.featured = true
      expect(Featured.count).to eq 1
      expect(data.featured?).to eq true
    end

    it "set as featured" do
      data.featured = true
      expect(Featured.count).to eq 1
      expect(data.featured?).to eq true
      data.featured = false
      expect(Featured.count).to eq 0
      expect(data.featured?).to eq false
    end
  end

  describe "destroy featured for the object when its destroyed" do
    let(:other_data) { FactoryGirl.create :geo_data, name: 'other' }

    before do
      Featured.destroy_all
      data.featured = true
      other_data.featured = true
    end

    it "destroy contributings for the contributable" do
      expect(Featured.count).to eq 2
      data.destroy
      expect(Featured.count).to eq 1
    end
  end
end
