require 'spec_helper'

describe FeaturedController do
  #TODO: refactor to user de real implementation of `admin?' to check
  #      permission
  let(:user) { FactoryGirl.create :user, id: 2}
  let(:geo_data) { FactoryGirl.create :geo_data }

  let(:params) { {geo_data_id: geo_data.id} }
  let(:featured_response) { {ok: true, featured: true}.to_json }
  let(:not_featured_response) { {ok: true, featured: false}.to_json }

  before do
    login_user user
    Featured.destroy_all
  end

  describe "POST create" do
    it "adds as featured" do
      expect(geo_data.featured?).to eq false
      post :create, params
      expect(response.header['Content-Type']).to match 'application/json'
      expect(response.body).to match featured_response
      expect(geo_data.reload.featured?).to eq true
    end

    it "do not creates duplicated 'featured'" do
      expect(geo_data.featured?).to eq false
      expect(Featured.count).to eq 0

      post :create, params
      expect(response.body).to match featured_response
      expect(geo_data.reload.featured?).to eq true
      expect(Featured.count).to eq 1

      post :create, params
      expect(Featured.count).to eq 1
    end
  end

  describe "DELETE destroy" do
    it "sets as not featured" do
      geo_data.featured = true
      expect(geo_data.featured?).to eq true
      expect(Featured.count).to eq 1

      delete :destroy, params

      expect(response.header['Content-Type']).to match 'application/json'
      expect(response.body).to match not_featured_response
      expect(geo_data.reload.featured?).to eq false
      expect(Featured.count).to eq 0
    end

    it "Do nothing if there is no matching following" do
      delete :destroy, params

      expect(response.header['Content-Type']).to match 'application/json'
      expect(response.body).to match not_featured_response
      expect(geo_data.reload.featured?).to eq false
      expect(Featured.count).to eq 0
    end
  end

end
