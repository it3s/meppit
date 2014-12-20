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
    let(:user_attrs) { FactoryGirl.build(:user).attributes.merge :interests => "dev,ruby,rails" }

    context "valid request" do
      let(:params) do
        {
          :user => user_attrs.merge(:password => '123456',
              :password_confirmation => '123456', :license_aggrement => '1')
        }
      end

      it "creates user and send activation mail" do
        User.any_instance.should_receive :send_activation_email
        expect { post :create, params }.to change { User.count }.by(1)
        expect(response.header['Content-Type']).to match 'application/json'
        expect(response.body).to match({:redirect => created_users_path}.to_json)
      end
    end

    context "invalid request" do
      let(:params) { {:user => user_attrs.merge(:password => '123456', :password_confirmation => '321654')} }

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

  describe "upload_avatar" do
    let(:user) { FactoryGirl.create :user }
    let(:file) { File.join(Rails.root, 'app', 'assets', 'images', 'imgs', 'avatar-placeholder.png') }
    let(:invalid_file) { File.join(Rails.root, 'app', 'assets', 'images', 'gifs', 'spinner.gif') }

    before { login_user user }

    context 'valid' do
      it "saves avatar" do
        expect(user.avatar?).to be false
        patch :upload_avatar, {user: {avatar: Rack::Test::UploadedFile.new(file)}, id: user.id}
        user.reload
        expect(response.status).to eq 200
        expect(user.avatar?).to be true
      end
    end
    context 'invalid' do
      it "raise validation errors" do
        expect(user.avatar?).to be false
        patch :upload_avatar, {user: {avatar: Rack::Test::UploadedFile.new(invalid_file)}, id: user.id}
        expect(response.status).to eq 422
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
        let(:errors_json) { {:errors => {:password_confirmation => [controller.t('activerecord.errors.messages.confirmation', {:attribute => 'Password'})]}}.to_json }
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

  describe "GET show" do
    let(:user) { FactoryGirl.create :user }
    it 'calls find_user filter' do
      controller.should_receive :find_user
      get :show, {:id => user.id}
    end

    it 'sets user and render template' do
      get :show, {:id => user.id}
      expect(assigns :user).to eq user
      expect(response).to render_template :show
    end
  end

  describe "GET edit" do
    let(:user) { FactoryGirl.create :user }

    context "not logged in" do
      before { logout_user }
      it "require_login" do
        controller.should_receive :require_login
        get :edit, {:id => user.id}
        expect(controller).to_not render_template :edit
      end
    end

    context "logged in" do
      before { login_user user }

      it 'calls find_user filter' do
        controller.should_receive :find_user
        get :edit, {:id => user.id}
      end

      it 'sets user and render template' do
        get :edit, {:id => user.id}
        expect(assigns :user).to eq user
        expect(response).to render_template :edit
      end

      it 'denies access to other users' do
        another_user = FactoryGirl.create :user
        get :edit, {:id => another_user.id}
        expect(response).to redirect_to root_path
        expect(controller.flash[:notice]).to eq controller.t('access_denied')
      end
    end
  end

  describe "POST update" do
    let(:user) { FactoryGirl.create :user }
    let(:user_params) { {:contacts => {:address => "rua Bla", :phone => "12345"},
                         :about_me => "<h2>Test</h2> <p>save html text</p>",
                         :name => user.name} }

    context "not logged in" do
      before { logout_user }
      it "require_login" do
        controller.should_receive :require_login
        post :update, {:id => user.id}
        expect(controller.status).to eq 302
      end
    end

    context "logged in" do
      before { login_user user }

      it 'calls find_user filter' do
        controller.should_receive :find_user
        post :update, {:id => user.id}
      end

      it 'cleans contacts field' do
        user_params.merge! :site => "", :twitter => ""
        post :update, {:id => user.id, :user => user_params}
        expect(controller.send(:user_params)[:contacts].keys).to match_array ['address', 'phone']
      end

      it 'saves user and return redirect' do
        post :update, {:id => user.id, :user => user_params}
        expect(assigns :user).to eq user
        expect(response.body).to match({:redirect => user_path(user)}.to_json)
        user.reload
        expect(user.contacts).to eq({'address' => 'rua Bla', 'phone' => '12345'})
        expect(user.about_me).to eq "<h2>Test</h2> <p>save html text</p>"
      end

      it 'validates model and returns errors' do
        post :update, {:id => user.id, :user => user_params.merge!(:name => "")}
        expect(assigns :user).to eq user
        expect(response.body).to eq({:errors => {:name => [controller.t('activerecord.errors.messages.blank')]}}.to_json)
        user.reload
      end


      it 'denies access to other users' do
        another_user = FactoryGirl.create :user
        post :update, {:id => another_user.id}
        expect(response).to redirect_to root_path
        expect(controller.flash[:notice]).to eq controller.t('access_denied')
      end
    end
  end
end
