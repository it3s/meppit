require 'spec_helper'

describe FollowingsController do
  let(:user) { FactoryGirl.create :user }
  let(:geo_data) { FactoryGirl.create :geo_data }

  let(:params) { {geo_data_id: geo_data.id} }
  let(:following_response) { {ok: true, following: true, count: 1}.to_json }
  let(:not_following_response) { {ok: true, following: false, count: 0}.to_json }
  let(:not_ok_response) { {ok: false}.to_json }

  before { login_user user }

  describe "POST create" do
    it "Adds following" do
      expect(user.followings.count).to eq 0
      post :create, params
      expect(response.header['Content-Type']).to match 'application/json'
      expect(response.body).to match following_response
      expect(user.reload.followings.count).to eq 1
    end

    it "Do not creates duplicated following" do
      expect(user.followings.count).to eq 0

      post :create, params
      expect(response.body).to match following_response
      expect(user.reload.followings.count).to eq 1

      post :create, params
      expect(user.reload.followings.count).to eq 1
    end

    it "Do not follow itself" do
      post :create, {user_id: user.id}

      expect(response.status).to eq 422
      expect(response.body).to match not_ok_response
    end
  end

  describe "DELETE destroy" do
    it "deletes following" do
      user.followings.create followable: geo_data
      expect(user.reload.followings.count).to eq 1

      delete :destroy, params

      expect(response.header['Content-Type']).to match 'application/json'
      expect(response.body).to match not_following_response
      expect(user.reload.followings.count).to eq 0
    end

    it "Do nothing if there is no matching following" do
      delete :destroy, params

      expect(response.body).to match not_ok_response
      expect(response.status).to eq 422
      expect(user.reload.followings.count).to eq 0
    end
  end

  describe "GET followers from geo_data" do
    context "regular request" do
      it 'defines @geo_data' do
        get :followers, :geo_data_id => geo_data.id
        expect(assigns :geo_data).to eq geo_data
      end

      it 'renders geo_data followers list using geo_data layout' do
        get :followers, :geo_data_id => geo_data.id
        expect(response).to render_template :geo_data
      end
    end
    context "xhr" do
      before { controller.request.stub(:xhr?).and_return(true) }

      it 'renders followers list without layout' do
        get :followers, :geo_data_id => geo_data.id
        expect(response).to render_template(:layout => nil)
      end
    end
  end

  describe "GET followers from user" do
    context "regular request" do
      it 'defines @user' do
        get :followers, :user_id => user.id
        expect(assigns :user).to eq user
      end

      it 'renders user followers list using users layout' do
        get :followers, :user_id => user.id
        expect(response).to render_template :users
      end
    end
    context "xhr" do
      before { controller.request.stub(:xhr?).and_return(true) }

      it 'renders followers list without layout' do
        get :followers, :user_id => user.id
        expect(response).to render_template(:layout => nil)
      end
    end
  end

  describe "GET following" do
    context "regular request" do
      it 'defines @user' do
        get :following, :user_id => user.id
        expect(assigns :user).to eq user
      end

      it 'renders following list using users layout' do
        get :following, :user_id => user.id
        expect(response).to render_template :users
      end
    end
    context "xhr" do
      before { controller.request.stub(:xhr?).and_return(true) }

      it 'renders contributions list without layout' do
        get :following, :user_id => user.id
        expect(response).to render_template(:layout => nil)
      end
    end
  end
end
