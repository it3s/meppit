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

  it 'validates format of email' do
    user.email = 'invalidmail'
    expect(user.valid?).to be_false
    expect(user.errors[:email].first).to eq 'invalid e-mail address'

    user.email = 'valid@email.com'
    expect(user.valid?).to be_true
  end

  it 'validates length of password'  do
    user = FactoryGirl.build(:user)
    user.password = '123'
    expect(user.valid?).to be_false
    expect(user.errors[:password].first).to eq 'is too short (minimum is 6 characters)'
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

end
