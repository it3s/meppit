require 'spec_helper'

describe Settings do
  let(:user) { FactoryGirl.create :user, language: 'en', mail_notifications: 'daily'}
  let(:settings) { Settings.new user }

  describe 'initialize' do
    it { expect(settings.language).to eq user.language }
    it { expect(settings.auth_token).to eq user.auth_token }
    it { expect(settings.mail_notifications).to eq user.mail_notifications }
    it { expect(settings.user).to eq user }
  end

  describe 'assign_attributes' do
    before { settings.assign_attributes language: 'pt-BR', mail_notifications: 'weekly' }
    it { expect(settings.language).to eq 'pt-BR' }
    it { expect(settings.mail_notifications).to eq 'weekly' }
  end

  describe 'save' do
    it "saves settings on user model" do
      expect(user.language).to eq 'en'
      expect(user.mail_notifications).to eq 'daily'

      settings.assign_attributes language: 'pt-BR', mail_notifications: 'weekly'
      expect(settings.save).to eq true

      user.reload
      expect(user.language).to eq 'pt-BR'
      expect(user.mail_notifications).to eq 'weekly'
    end
  end

end
