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
  it { expect(subject).to have_db_column :location }
  it { expect(subject).to have_db_column :mail_notifications }

  it 'validates format of email' do
    user.email = 'invalidmail'
    expect(user.valid?).to be false
    expect(user.errors[:email].first).to eq I18n.t('activerecord.errors.models.user.attributes.email.invalid')

    user.email = 'valid@email.com'
    expect(user.valid?).to be true
  end

  it 'validates length of password'  do
    user = FactoryGirl.build(:user)
    user.password = '123'
    expect(user.valid?).to be false
    expect(user.errors[:password].first).to eq I18n.t('activerecord.errors.messages.too_short', {:count => 6})
  end

  it 'contacts is a hstore and accepts data in hash format' do
    user = FactoryGirl.build(:user)
    user.contacts = {'test' => 'ok', 'address' => 'av paulista, 800, SP'}
    expect(user.save).to be true
    expect(User.find_by(:id => user.id).contacts).to eq({'test' => 'ok', 'address' => 'av paulista, 800, SP'})
  end

  it "has default for mail_notifications" do
    user = FactoryGirl.create(:user)
    expect(user.mail_notifications).to eq 'daily'
  end

  describe "encryption matches legacy DB" do
    let(:salt) { 'batata-frita' }

    before do
      @orig_value = ENV['FIXED_SALT']
      ENV['FIXED_SALT'] = salt
    end
    after do
      ENV['FIXED_SALT'] = @orig_value
    end

    let(:password) { FactoryGirl.build(:user).password }
    let(:crypted_password) { Digest::SHA1.hexdigest(salt + password) }

    it { expect(user.crypted_password).to eq crypted_password }
    it { expect(User.authenticate(user.email, password)).to be_a_kind_of User }
    it { expect(User.authenticate(user.email, 'wrong password')).to be_nil }
  end

  describe "send activation email" do
    it "enqueues to sidekiq" do
      expect { user.send_activation_email}.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end
  end

  describe "send reset password email" do
    it "enqueues to sidekiq" do
      expect { user.send_reset_password_email!}.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end
  end

  describe "avatar" do
    it { expect(user.avatar).to be_a_kind_of AvatarUploader }
  end

  describe "geojson properties" do
    it "should have id" do
      expect(user.geojson_properties).to have_key(:id)
    end
  end

  describe "activities_performed" do
    let(:geo_data) { FactoryGirl.create :geo_data }
    let(:map) { FactoryGirl.create :map }

    before do
      geo_data.create_activity :update, owner: user
      map.create_activity :follow, owner: user
    end

    it { expect(user.activities_performed.count).to eq 2 }
    it { expect(user.activities_performed.first.trackable).to eq map }
    it { expect(user.activities_performed.first.key).to eq 'map.follow' }
    it { expect(user.activities_performed.last.trackable).to eq geo_data }
    it { expect(user.activities_performed.last.key).to eq 'geo_data.update' }
  end

  describe "notifications" do
    let(:user) { FactoryGirl.create :user }
    let(:other_user) { FactoryGirl.create :user, name: 'other' }
    let(:geo_data) { FactoryGirl.create :geo_data }
    let(:activity) { geo_data.create_activity :update, owner: other_user, parameters: {changes: {"name"=>["", geo_data.name]}} }
    let!(:notification) { Notification.create user: user, activity: activity }

    it { expect(user.notifications.count).to eq 1 }
    it { expect(user.notifications.first).to eq notification }
    it { expect(user.notifications.explain).to match 'created_at desc' }

    describe "#unread_notifications_count" do
      it { expect(user.unread_notifications_count).to eq 1 }
    end
  end

  describe "with_interests" do
    before do
      FactoryGirl.create :user, interests: ['aa', 'bb']
      FactoryGirl.create :user, interests: ['aa']
      FactoryGirl.create :user, interests: ['bb', 'cc']
    end

    it { expect(User.with_interests(['cc']).count).to eq 1}
    it { expect(User.with_interests(['aa']).count).to eq 2}
    it { expect(User.with_interests(['aa', 'bb']).count).to eq 1}
    it { expect(User.with_interests(['aa', 'bb'], :any).count).to eq 3}
  end

  describe "auth_token" do
    before { FactoryGirl.create :user }

    it { expect(user.auth_token).to_not be nil }
  end

  describe "settings" do
    let(:user) { FactoryGirl.build :user }

    it "build settings model for the user" do
      expect(Settings).to receive(:new).with(user)
      user.settings
    end
  end

  describe "#admin?" do
    let!(:user) { FactoryGirl.create :user }

    context "is not an admin" do
      it { expect(user.admin?).to be false }
    end

    context "is admin" do
      let!(:admin) { Admin.create(user: user) }
      it { expect(user.admin?).to be true }
    end
  end
end
