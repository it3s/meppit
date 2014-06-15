require 'spec_helper'

# These specs test mostly if we pass correctly the expected calls to the
# underlying sorcery engine (which is already properly tested, thats why all
# the stubs and expect/receive's )
describe AuthenticationsController do
  describe "#oauth" do
    let(:params) { {:provider => :facebook} }
    it 'call login_at for the provide' do
      expect(controller).to receive(:login_at).with('facebook')
      get :oauth, params
    end
  end

  describe "create_user_from_provider" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      controller.stub(:create_from) { user }
      controller.params =  {:provider => :facebook}
    end

    it 'created from providers user_info' do
      expect(controller).to receive(:create_from)
      expect(user).to receive(:activate!)
      controller.send :create_user_from_provider
    end
  end

  describe "add_provider_to_existent_user" do
    let!(:user) { FactoryGirl.create :user }
    before do
      controller.instance_variable_set :@user_hash, { :user_info => user.attributes }
    end

    it "add provider to user verifying by its e-mail" do
      expect(controller).to receive :add_provider_to_user
      controller.send :add_provider_to_existent_user
      expect(controller.current_user).to eq user
    end
  end

  describe "add_provider" do
    let(:user) { FactoryGirl.build(:user) }
    before { controller.instance_variable_set(:@user, user) }

    it "trys frist to add to existing user" do
      controller.stub(:add_provider_to_existent_user) { user }

      expect(controller).to receive :add_provider_to_existent_user
      expect(controller).to_not receive(:create_user_from_provider)
      controller.send :add_provider
      expect(controller.logged_in?).to be true
    end

    it "if user dont exist create from provider" do
      controller.stub(:add_provider_to_existent_user).and_return nil
      controller.stub(:create_user_from_provider) { user }

      expect(controller).to receive(:create_user_from_provider)
      controller.send :add_provider
      expect(controller.logged_in?).to be true
    end
  end

  describe "#callback" do
    context "has user and provider" do
      let(:user) { FactoryGirl.create(:user) }
      let(:params) { {:provider => :facebook} }

      before { controller.stub(:login_from) { controller.auto_login(user); user }}

      it "expects to login" do
        expect(controller).to receive :login_from
        expect(controller).to_not receive :add_provider
        get :callback, params
        expect(controller).to redirect_to root_path
      end
    end

    context "new provider" do
      let(:user) { FactoryGirl.create(:user) }
      let(:params) { {:provider => :facebook} }

      before do
        controller.stub(:login_from) { nil }
        controller.stub(:add_provider) { }
      end

      it "expects to login" do
        expect(controller).to receive :add_provider
        get :callback, params
        expect(controller).to redirect_to root_path
      end
    end
  end
end
