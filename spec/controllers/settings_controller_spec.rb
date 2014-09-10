require 'spec_helper'

describe SettingsController do
  let(:user) { FactoryGirl.create :user, language: 'en', mail_notifications: 'daily' }

  before { login_user user }

  describe "GET show" do
    it 'renders setings page' do
      get :show, id: user.id
      expect(assigns :user).to eq user
      expect(assigns :settings).to eq user.settings
      expect(response).to render_template :show
    end

    it "redirects if not user itself" do
      other = FactoryGirl.create :user
      get :show, id: other.id
      expect(response).to redirect_to controller.root_path
    end
  end

  describe "GET show" do
    it 'renders setings page' do
      expect(user.language).to eq 'en'
      expect(user.mail_notifications).to eq 'daily'

      patch :update, id: user.id, settings: {mail_notifications: 'weekly', language: 'pt-BR' }

      expect(response.status).to eq 200
      expect(response.body).to include({redirect: controller.user_path(user)}.to_json)

      user.reload
      expect(user.language).to eq 'pt-BR'
      expect(user.mail_notifications).to eq 'weekly'
    end

    it "redirects if not user itself" do
      other = FactoryGirl.create :user
      patch :update, id: other.id
      expect(response).to redirect_to controller.root_path
    end
  end

end
