require 'spec_helper'

describe "Embed::V1::Maps" do
  let(:map) { FactoryGirl.create :map }
  let(:data) { FactoryGirl.create :geo_data }
  let(:user) { FactoryGirl.create :user }

  before { map.add_geo_data data }

  describe "GET show" do
    before { get "/embed/v1/maps/#{map.id}" }
    it "allows cross-domain iframe" do
      expect(response.headers['X-Frame-Options']).to eq "ALLOWALL"
    end

    it "has map component" do
      expect(response.status).to eq 200
      expect(response.body).to match 'class="map"'
      expect(response.body).to match 'data-map-options'
    end

    it "has layers list" do
      expect(response.status).to eq 200
      expect(response.body).to match 'class="layers-list"'
    end
  end

  describe "GET help" do
    before { get "/embed/v1/maps/help" }

    it "doesn't render layout" do
      expect(response.status).to eq 200
      expect(response.body).to_not match '<html'
      expect(response.body).to_not match '<body'
    end
  end
end
