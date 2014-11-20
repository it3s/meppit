require 'spec_helper'

describe FlagsController do
  let(:user) { FactoryGirl.create :user }
  let(:geo_data) { FactoryGirl.create :geo_data }
  before { allow(controller.request).to receive(:referer).and_return "http://test.host/geo_data/#{geo_data.id}" }

  describe "GET new" do
    it "requires login" do
      get :new
      expect(response).to redirect_to login_path
    end

    it "when logged assings flag and render template" do
      login_user user
      get :new, geo_data_id: geo_data.id
      expect(assigns :flag).to be_a_kind_of Flag
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    let(:params) { { flag: { content: 'foo bar', reason: 'tos_violation'} } }
    before { login_user user }

    it "creates the flag" do
      expect(Flag.where(user: user).count).to eq 0
      post :create, params
      expect(Flag.where(user: user).count).to eq 1
      expect(response.status).to eq 200
    end
  end

  describe "POST mark_as_solved" do
    let!(:flag) { Flag.create user: user, flaggable: geo_data, reason: 'tos_violation' }
    before { login_user user }

    it "requires admin" do
      post :mark_as_solved, id: flag.id
      expect(response).to redirect_to root_path
    end

    context "admin" do
      before { Admin.create user: user }

      it "mark as solved" do
        expect(flag.solved).to eq false
        post :mark_as_solved, id: flag.id
        expect(flag.reload.solved).to eq true
        expect(response).to redirect_to admin_path(user)
      end
    end
  end
end
