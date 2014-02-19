require 'spec_helper'
require "digest/sha1"

describe User do

  it { expect(subject).to have_db_index(:email).unique(:true) }
  it { expect(subject).to validate_presence_of :email }
  it { expect(subject).to validate_presence_of :password  }
  it { expect(subject).to validate_confirmation_of :password }

  describe "encryption matches legacy DB" do
    before(:all) do
      @salt = 'batata-frita'
      Rails.application.config.SECRETS[:fixed_salt] = @salt
    end

    let(:params) { {:name => 'John', :email => 'john@doe.com', :password => 'abcde' } }
    let(:user) { User.create!(params) }
    let(:crypted_password) { Digest::SHA1.hexdigest(@salt + params[:password]) }

    it { expect(user.crypted_password).to eq crypted_password }
    it { expect(User.authenticate(user.email, params[:password])).to be_a_kind_of User }
    it { expect(User.authenticate(user.email, 'wrong password')).to be_nil }
  end
end
