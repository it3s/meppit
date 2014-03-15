require 'spec_helper'
require "digest/sha1"

describe User do
  let(:user) { FactoryGirl.create(:user) }

  it { expect(subject).to have_db_index(:email).unique(:true) }
  it { expect(subject).to validate_presence_of :email }
  it { expect(subject).to validate_presence_of :name }
  it { expect(subject).to validate_presence_of :password  }
  it { expect(subject).to validate_confirmation_of :password }
  it { expect(subject).to validate_acceptance_of :license_aggrement }
  it { expect(subject).to have_db_column :language }
  it { expect(subject).to have_db_column :about_me }
  it { expect(subject).to have_db_column :contacts }
  it { expect(subject).to have_db_column :avatar }

  it 'validates format of email' do
    user.email = 'invalidmail'
    expect(user.valid?).to be_false
    expect(user.errors[:email].first).to eq I18n.t('activerecord.errors.models.user.attributes.email.invalid')

    user.email = 'valid@email.com'
    expect(user.valid?).to be_true
  end

  it 'validates length of password'  do
    user = FactoryGirl.build(:user)
    user.password = '123'
    expect(user.valid?).to be_false
    expect(user.errors[:password].first).to eq I18n.t('activerecord.errors.messages.too_short', {:count => 6})
  end

  it 'contacts is a hstore and accepts data in hash format' do
    user = FactoryGirl.build(:user)
    user.contacts = {'test' => 'ok', 'address' => 'av paulista, 800, SP'}
    expect(user.save).to be_true
    expect(User.find_by(:id => user.id).contacts).to eq({'test' => 'ok', 'address' => 'av paulista, 800, SP'})
  end

  describe "encryption matches legacy DB" do
    let(:salt) { 'batata-frita' }

    before do
      Rails.application.config.stub(:SECRETS).and_return({:fixed_salt => salt })
    end

    let(:password) { FactoryGirl.build(:user).password }
    let(:crypted_password) { Digest::SHA1.hexdigest(salt + password) }

    it { expect(user.crypted_password).to eq crypted_password }
    it { expect(User.authenticate(user.email, password)).to be_a_kind_of User }
    it { expect(User.authenticate(user.email, 'wrong password')).to be_nil }
  end

  describe "send activation email" do
    it "enqueues to sidekiq" do
      expect { UserMailer.delay.activation_email(user.id)}.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end
  end

  describe "send reset password email" do
    it "enqueues to sidekiq" do
      expect { UserMailer.delay.reset_password_email(user.id)}.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end
  end

  describe "avatar" do
    it { expect(user.avatar).to be_a_kind_of AvatarUploader }
  end
end
