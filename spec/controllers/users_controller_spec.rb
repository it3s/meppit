require 'spec_helper'

describe UsersController do
  describe "GET new" do
    context "regular request" do
      it 'renders new user form' do
        get :new
        expect(assigns :user).to be_a_kind_of User
        expect(response).to render_template :new
      end
    end

    context "xhr" do
      before { controller.request.stub(:xhr?).and_return(true) }

      it 'renders new user form without layout' do
        get :new
        expect(assigns :user).to be_a_kind_of User
        expect(response).to render_template(:layout => nil)
      end
    end
  end

  describe "POST create" do
    let(:user_attrs) { FactoryGirl.build(:user).attributes }

    context "valid request" do
      let(:params) do
        {
          :user => user_attrs.merge(password: '123',
              password_confirmation: '123', license_aggrement: '1')
        }
      end

      it "creates user and send activation mail" do
        User.any_instance.should_receive :send_activation_email
        expect { post :create, params }.to change { User.count }.by(1)
        expect(response.header['Content-Type']).to match 'application/json'
        expect(response.body).to match({redirect: created_users_path}.to_json)
      end
    end

    context "invalid request" do
      let(:params) { {:user => user_attrs.merge(password: '123', password_confirmation: '321')} }

      it "return json with errors and status=:unprocessable_entity " do
        post :create, params
        expect(response.header['Content-Type']).to match 'application/json'
        expect(response.status).to eq 422
        expect(response.body).to match 'errors'
      end
    end
  end

  describe "GET created" do
    before { get :created }
    it { expect(response).to render_template :created }
  end

  describe "GET activate" do
    let!(:user) { FactoryGirl.create(:pending_user) }

    context "valid token" do
      it "activates the user and redirect to root" do
        User.any_instance.should_receive(:activate!)
        get :activate, :id => user.activation_token
        expect(response).to redirect_to root_path
      end
    end

    context 'invalid token' do
      it "calls not_authenticated" do
        controller.should_receive(:not_authenticated)
        get :activate, :id => "invalid"
      end
    end
  end
end
