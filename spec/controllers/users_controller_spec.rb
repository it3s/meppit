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
          :user => user_attrs.merge(password: '123456',
              password_confirmation: '123456', license_aggrement: '1')
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
      let(:params) { {:user => user_attrs.merge(password: '123456', password_confirmation: '321654')} }

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

  describe "PasswordResets" do
    let!(:user) { FactoryGirl.create(:user, :reset_password_token => 'abcdef', :reset_password_token_expires_at => Time.now + 2.days) }
    let(:params) { {:token => 'abcdef'} }

    describe "#forgot_password" do
      before { get :forgot_password }
      it { expect(response).to render_template :layout => nil }
    end

    describe "#reset_password" do
      before { params.merge! :email => user.email }

      it "find user and send email" do
        User.any_instance.should_receive :deliver_reset_password_instructions!
        post :reset_password, params
        expect(controller.instance_variable_get :@user).to eq user
        expect(response).to redirect_to root_path
        expect(controller.flash[:notice]).to eq controller.t('users.forgot_password.email_sent')
      end
    end

    describe "#edit_password" do
      before { get :edit_password, params }

      it "sets user and token" do
        expect(controller.instance_variable_get :@token).to eq params[:token]
        expect(controller.instance_variable_get :@user).to eq user
      end

      it { expect(response).to render_template :edit_password }
    end

    describe "#update_password" do
      context "valid params" do
        before { params.merge! :user => {:password => '123456', :password_confirmation => '123456', :email => user.email} }
        it 'changes password and redirect to root' do
          expect(controller.login user.email, '123456').to be_nil
          post :update_password, params
          expect(controller.login user.email, '123456').to eq user
          expect(response.body).to match({:redirect => root_path}.to_json)
          expect(controller.flash[:notice]).to eq controller.t('users.forgot_password.updated')
        end
      end

      context "invalid params" do
        let(:errors_json) { {:errors => {:password_confirmation => ["doesn't match Password"]}}.to_json }
        before { params.merge! :user => {:password => '123456', :password_confirmation => '654321', :email => user.email} }
        it 'return errors' do
          post :update_password, params
          expect(controller.login user.email, '123456').to be_nil
          expect(response.body).to eq errors_json
          expect(response.status).to eq 422
        end
      end
    end
  end
end
