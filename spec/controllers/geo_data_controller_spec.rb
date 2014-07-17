require 'spec_helper'

describe GeoDataController do
  let(:geo_data) { FactoryGirl.create :geo_data }
  let(:map)      { FactoryGirl.create :map }
  let(:user)     { FactoryGirl.create :user }

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
    it 'calls find_geo_data filter' do
      controller.should_receive :find_geo_data
      get :show, {:id => geo_data.id}
    end

    it 'sets geo_data and render template' do
      get :show, {:id => geo_data.id}
      expect(assigns :geo_data).to eq geo_data
      expect(response).to render_template :show
    end
  end

  describe "GET edit" do
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
    let(:data_params) { {:description => "<h2>Test</h2> <p>save html text</p>",
                         :name => geo_data.name} }

    before { login_user user }

    it 'saves geo_data and return redirect' do
      post :update, {:id => geo_data.id, :geo_data => data_params}
      expect(assigns :geo_data).to eq geo_data
      expect(response.body).to match({:redirect => geo_data_path(geo_data)}.to_json)
      expect(geo_data.reload.description).to eq "<h2>Test</h2> <p>save html text</p>"
    end

    it 'validates model and returns errors' do
      post :update, {:id => geo_data.id, :geo_data => data_params.merge!(:name => "")}
      expect(assigns :geo_data).to eq geo_data
      expect(response.body).to eq({:errors => {:name => [controller.t('activerecord.errors.messages.blank')]}}.to_json)
    end
  end

  describe "GET maps from geo_data" do
    let!(:geo_data) { FactoryGirl.create :geo_data }
    context "regular request" do
      it 'renders maps list with layout' do
        get :maps, :id => geo_data.id
        expect(response).to render_template :application
      end
    end
    context "xhr" do
      before { controller.request.stub(:xhr?).and_return(true) }

      it 'renders maps list without layout' do
        get :maps, :id => geo_data.id
        expect(response).to render_template(:layout => nil)
      end
    end
  end

  describe "GET search_by_name" do
    before do
      FactoryGirl.create :geo_data, id: 1, name: 'organization'
      FactoryGirl.create :geo_data, id: 2, name: 'bla'
      FactoryGirl.create :geo_data, id: 3, name: 'ble'
    end

    it "searches geo_data by name" do
      get :search_by_name, term: "bl"
      expect(response.body).to eq '[{"value":"bla","id":2},{"value":"ble","id":3}]'
    end
  end

  describe "POST add_to_map" do
    before { login_user user }

    context "success" do
      before { post :add_to_map, {id: geo_data.id, map: map.id} }
      it { expect(response.body).to eq({flash: "", count: 1}.to_json) }
    end

    context "failure" do
      it "returns invalid message" do
        expect(controller).to receive(:flash_xhr).with I18n.t('geo_data.add_to_map.invalid')
        post :add_to_map, {id: geo_data.id, map: nil}
        expect(response.status).to eq 422
      end
    end
  end

  describe "create_mapping" do
    before { controller.instance_variable_set "@geo_data", geo_data }

    it "calls add_to_map on geo_data" do
      expect(geo_data).to receive(:add_to_map).with(map).and_return(double(id: nil))
      controller.send :create_mapping, map
    end
    it "returns added message when create mapping" do
      allow(geo_data).to receive(:add_to_map).with(map).and_return(double(id: 1))
      expect(controller.send(:create_mapping, map)[1]).to eq I18n.t('geo_data.add_to_map.added', map: map.name)
    end
    it "returns exists message when create mapping" do
      allow(geo_data).to receive(:add_to_map).with(map).and_return(double(id: nil))
      expect(controller.send(:create_mapping, map)[1]).to eq I18n.t('geo_data.add_to_map.exists', map: map.name)
    end
  end
end
