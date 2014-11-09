require 'spec_helper'

describe AdminsController do
  let(:user) { FactoryGirl.create :user }
  before { login_user user }

  describe "GET show" do
    context 'not admin' do
      it "denies access" do
        get :show, id: user
        expect(response).to redirect_to root_path
      end
    end

    context "valid request" do
      before { Admin.create user: user }

      it 'renders new user form' do
        get :show, id: user.id
        expect(assigns :unsolved_flags).to_not be nil
        expect(assigns :solved_flags).to_not be nil
        expect(response).to render_template :show
      end
    end

  end

  describe "GET confirm_deletion" do
    let(:geo_data) { FactoryGirl.create :geo_data }
    before { Admin.create user: user }

    it "find_deletable" do
      allow(controller.request).to receive(:referer).and_return "http://test.host/geo_data/#{geo_data.id}"
      get :confirm_deletion, id: user.id

      expect(assigns :deletable).to eq geo_data
      expect(response).to render_template :confirm_deletion
    end
  end

  describe "POST delete_object" do
    let(:geo_data) { FactoryGirl.create :geo_data }
    before { Admin.create user: user }

    it "deletes object" do
      allow(controller.request).to receive(:referer).and_return "http://test.host/geo_data/#{geo_data.id}"
      expect(GeoData.where(id: geo_data.id).first).to_not be nil

      get :delete_object, id: user.id

      expect(assigns :deletable).to eq geo_data
      expect(response).to redirect_to root_path
      expect(GeoData.where(id: geo_data.id).first).to be nil
    end
  end
end
