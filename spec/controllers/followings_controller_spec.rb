require 'spec_helper'

describe FollowingsController do
  let(:user) { FactoryGirl.create :user }
  let(:geo_data) { FactoryGirl.create :geo_data }

  let(:params) { {geo_data_id: geo_data.id} }
  let(:ok_response) { {ok: true}.to_json }

  before { login_user user }

  describe "POST create" do
    it "Adds following" do
      expect(user.followings.count).to eq 0
      post :create, params
      expect(response.header['Content-Type']).to match 'application/json'
      expect(response.body).to match ok_response
      expect(user.reload.followings.count).to eq 1
    end

    it "Do not creates duplicated following" do
      expect(user.followings.count).to eq 0
      post :create, params
      expect(user.reload.followings.count).to eq 1
      post :create, params
      expect(user.reload.followings.count).to eq 1
    end
  end

  describe "DELETE destroy" do
    it "deletes following" do
      user.followings.create followable: geo_data
      expect(user.reload.followings.count).to eq 1

      delete :destroy, params

      expect(response.header['Content-Type']).to match 'application/json'
      expect(response.body).to match ok_response
      expect(user.reload.followings.count).to eq 0
    end

    it "Do notthing if there is no matching following" do
      delete :destroy, params

      expect(response.body).to match ok_response
      expect(user.reload.followings.count).to eq 0
    end
  end
end
