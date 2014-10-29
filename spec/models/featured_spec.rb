require 'spec_helper'

describe Featured do
  let(:map) { FactoryGirl.create(:map, name: 'Test map') }
  let(:geo_data) { FactoryGirl.create :geo_data, name: 'Test object' }

  before { Featured.delete_all }

  describe "polymorphic featurables" do
    before { Featured.create featurable: featurable }

    context "a map can be featured" do
      let(:featurable) { map }
      let(:featured) { Featured.first }

      it { expect(featured).to_not be_nil }
      it { expect(featured.featurable.name).to eq 'Test map' }
      it { expect(featured.featurable).to be_a_kind_of Map }
    end

    context "a user can follow an object" do
      let(:featurable) { geo_data }
      let(:featured) { Featured.first }

      it { expect(featured).to_not be_nil }
      it { expect(featured.featurable.name).to eq 'Test object' }
      it { expect(featured.featurable).to be_a_kind_of GeoData }
    end
  end

  describe "validations" do
    it "validates presence of featurable" do
      f = Featured.new
      expect(f.save).to be false
      expect(f.errors.messages[:featurable].size > 0).to be true
    end
  end
end
