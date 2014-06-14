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
    let(:geo_data) { FactoryGirl.create :geo_data }
    it 'calls find_geo_data filter' do
      controller.should_receive :find_geo_data
      get :show, {:id => geo_data.id}
    end

    it 'sets user and render template' do
      get :show, {:id => geo_data.id}
      expect(assigns :geo_data).to eq geo_data
      expect(response).to render_template :show
    end
  end

  describe "GET edit" do
    let(:geo_data) { FactoryGirl.create :geo_data }
    let(:user) { FactoryGirl.create :user }

    context "not logged in" do
      before { logout_user }
      it "require_login" do
        controller.should_receive :require_login
        get :edit, {:id => geo_data.id}
        expect(controller.logged_in?).to be false
      end
    end

    context "logged in" do
      before { login_user user }

      it 'calls find_geo_data filter' do
        controller.should_receive :find_geo_data
        get :edit, {:id => geo_data.id}
      end

      it 'sets geo_data and render template' do
        get :edit, {:id => geo_data.id}
        expect(assigns :geo_data).to eq geo_data
        expect(response).to render_template :edit
      end
    end
  end

  describe "POST update" do
    let!(:geo_data) { FactoryGirl.create :geo_data }
    let!(:user) { FactoryGirl.create :user }
    let(:data_params) { {:description => "<h2>Test</h2> <p>save html text</p>",
                         :name => geo_data.name} }

    before { login_user user }

    it 'saves geo_data and return redirect' do
      post :update, {:id => geo_data.id, :geo_data => data_params}
      expect(assigns :geo_data).to eq geo_data
      expect(response.body).to match({:redirect => geo_datum_path(geo_data)}.to_json)
      geo_data.reload
      expect(geo_data.description).to eq "<h2>Test</h2> <p>save html text</p>"
    end

    it 'validates model and returns errors' do
      post :update, {:id => geo_data.id, :geo_data => data_params.merge!(:name => "")}
      expect(assigns :geo_data).to eq geo_data
      expect(response.body).to eq({:errors => {:name => [controller.t('activerecord.errors.messages.blank')]}}.to_json)
      geo_data.reload
    end
  end

end
