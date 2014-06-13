require 'spec_helper'

describe GeoDataController do
  describe "GET index" do
    context "regular request" do
      it 'renders geo_data list' do
        get :index
        expect(response).to render_template :index
      end
    end
    context "xhr" do
      before { controller.request.stub(:xhr?).and_return(true) }

      it 'renders geo_data list without layout' do
        get :index
        expect(response).to render_template(:layout => nil)
      end
    end
  end

  describe "GET show" do
    let(:object) { FactoryGirl.create :geo_data }
    it 'calls find_object filter' do
      controller.should_receive :find_object
      get :show, {:id => object.id}
    end

    it 'sets user and render template' do
      get :show, {:id => object.id}
      expect(assigns :object).to eq object
      expect(response).to render_template :show
    end
  end

  describe "GET edit" do
    let(:object) { FactoryGirl.create :geo_data }
    let(:user) { FactoryGirl.create :user }

    context "not logged in" do
      before { logout_user }
      it "require_login" do
        controller.should_receive :require_login
        get :edit, {:id => object.id}
        expect(controller.logged_in?).to be false
      end
    end

    context "logged in" do
      before { login_user user }

      it 'calls find_object filter' do
        controller.should_receive :find_object
        get :edit, {:id => object.id}
      end

      it 'sets object and render template' do
        get :edit, {:id => object.id}
        expect(assigns :object).to eq object
        expect(response).to render_template :edit
      end
    end
  end

  describe "POST update" do
    let!(:object) { FactoryGirl.create :geo_data }
    let!(:user) { FactoryGirl.create :user }
    let(:data_params) { {:description => "<h2>Test</h2> <p>save html text</p>",
                         :name => object.name} }

    before { login_user user }

    it 'saves object and return redirect' do
      post :update, {:id => object.id, :geo_data => data_params}
      expect(assigns :object).to eq object
      expect(response.body).to match({:redirect => geo_datum_path(object)}.to_json)
      object.reload
      expect(object.description).to eq "<h2>Test</h2> <p>save html text</p>"
    end

    it 'validates model and returns errors' do
      post :update, {:id => object.id, :geo_data => data_params.merge!(:name => "")}
      expect(assigns :object).to eq object
      expect(response.body).to eq({:errors => {:name => [controller.t('activerecord.errors.messages.blank')]}}.to_json)
      object.reload
    end
  end

end
