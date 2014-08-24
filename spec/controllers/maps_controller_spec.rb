require "spec_helper"

describe MapsController do
  let(:map)      { FactoryGirl.create :map }
  let(:user)     { FactoryGirl.create :user }
  let(:geo_data) { FactoryGirl.create :geo_data }

  describe "GET index" do
    context "regular request" do
      let!(:map) { FactoryGirl.create :map }
      it 'renders maps list and asigns @maps_collection' do
        get :index
        expect(response).to render_template :index
        expect(assigns[:maps_collection]).to be_a_kind_of Map::ActiveRecord_Relation
        expect(assigns[:maps_collection].count).to eq 1
        expect(assigns[:maps_collection].first).to eq map
      end
    end
    context "xhr" do
      before { controller.request.stub(:xhr?).and_return(true) }

      it 'renders maps list without layout' do
        get :index
        expect(response).to render_template(:layout => nil)
      end
    end
  end

  describe "GET show" do
    it 'calls find_object filter' do
      controller.should_receive :find_object
      get :show, {:id => map.id}
    end

    it 'sets map and render template' do
      get :show, {:id => map.id}
      expect(assigns :map).to eq map
      expect(response).to render_template :show
    end
  end

  describe "GET new" do
    context "not logged in" do
      before { logout_user }
      it "require_login" do
        controller.should_receive :require_login
        get :new
        expect(controller.logged_in?).to be false
      end
    end

    context "logged in" do
      before { login_user user }

      it 'calls build_instance filter' do
        controller.should_receive :build_instance
        get :new
      end

      it 'sets map and render template' do
        get :new
        expect(assigns :map).to be_a_kind_of Map
        expect(response).to render_template :new
      end
    end
  end

  describe "POST create" do
    let(:map_params) { {:description => "<h2>Test</h2> <p>save html text</p>",
                         :name => "new nap"} }

    before { login_user user }

    it 'saves map and return redirect' do
      post :create, {:map => map_params}
      expect(assigns :map).to be_a_kind_of Map
      expect(response.body).to match({:redirect => map_path(assigns :map)}.to_json)
    end

    it "publishes map_updated to EventBus" do
      expect(EventBus).to receive(:publish).with("map_created", anything)
      post :create, {:map => map_params}
    end

    it 'validates model and returns errors' do
      post :create, {:map => map_params.merge!(:name => "")}
      expect(assigns :map).to be_a_kind_of Map
      expect(response.body).to eq({:errors => {:name => [controller.t('activerecord.errors.messages.blank')]}}.to_json)
    end
  end

  describe "GET edit" do
    context "not logged in" do
      before { logout_user }
      it "require_login" do
        controller.should_receive :require_login
        get :edit, {:id => map.id}
        expect(controller.logged_in?).to be false
      end
    end

    context "logged in" do
      before { login_user user }

      it 'calls find_object filter' do
        controller.should_receive :find_object
        get :edit, {:id => map.id}
      end

      it 'sets map and render template' do
        get :edit, {:id => map.id}
        expect(assigns :map).to eq map
        expect(response).to render_template :edit
      end
    end
  end

  describe "POST update" do
    let(:map_params) { {:description => "<h2>Test</h2> <p>save html text</p>",
                         :name => map.name} }

    before { login_user user }

    it 'saves map and return redirect' do
      post :update, {:id => map.id, :map => map_params}
      expect(assigns :map).to eq map
      expect(response.body).to match({:redirect => map_path(map)}.to_json)
      expect(map.reload.description).to eq "<h2>Test</h2> <p>save html text</p>"
    end

    it "publishes map_updated to EventBus" do
      expect(EventBus).to receive(:publish).with("map_updated", anything)
      post :update, {:id => map.id, :map => map_params}
    end

    it 'validates model and returns errors' do
      post :update, {:id => map.id, :map => map_params.merge!(:name => "")}
      expect(assigns :map).to eq map
      expect(response.body).to eq({:errors => {:name => [controller.t('activerecord.errors.messages.blank')]}}.to_json)
    end

    describe "validates additional_info yaml format" do
      context "valid for empty" do
        let(:yaml) { "" }
        before { post :update, {id: map.id, map: map_params.merge(additional_info: yaml)} }
        it { expect(response.status).to eq 200 }
      end
      context "valid for hash" do
        let(:yaml) { "foo: bar\n" }
        before { post :update, {id: map.id, map: map_params.merge(additional_info: yaml)} }
        it { expect(response.status).to eq 200 }
      end
      context "invalid for others" do
        let(:yaml) { "invalid string" }
        before { post :update, {id: map.id, map: map_params.merge(additional_info: yaml)} }
        it { expect(response.status).to eq 422 }
        it { expect(response.body).to eq({errors: {additional_info: [I18n.t('additional_info.invalid')]}}.to_json) }
      end
    end
  end

  describe "GET geo_data from maps" do
    before { map.mappings.create geo_data: geo_data }
    context "regular request" do
      it 'renders maps list with layout' do
        get :geo_data, :id => map.id
        expect(response).to render_template :geo_data
        expect(assigns[:geo_data_collection]).to be_a_kind_of ActiveRecord::AssociationRelation
        expect(assigns[:geo_data_collection].count).to eq 1
        expect(assigns[:geo_data_collection].first).to eq geo_data
      end
    end
    context "xhr" do
      before { controller.request.stub(:xhr?).and_return(true) }

      it 'renders geo_data list without layout' do
        get :geo_data, :id => map.id
        expect(response).to render_template(:layout => nil)
      end
    end
  end

  describe "GET search_by_name" do
    before do
      FactoryGirl.create :map, id: 1, name: 'organizations in SP'
      FactoryGirl.create :map, id: 2, name: 'bla'
      FactoryGirl.create :map, id: 3, name: 'ble'
    end

    it "searches map by name" do
      get :search_by_name, term: "bl"
      expect(response.body).to eq '[{"value":"bla","id":2},{"value":"ble","id":3}]'
    end
  end

  describe "POST add_geo_data" do
    before { login_user user }

    context "success" do
      before { post :add_geo_data, {id: map.id, geo_data: geo_data.id} }
      it { expect(response.body).to eq({flash: "", count: 1}.to_json) }
    end

    context "failure" do
      it "returns invalid message" do
        expect(controller).to receive(:flash_xhr).with I18n.t('maps.add_geo_data.invalid')
        post :add_geo_data, {id: map.id, geo_data: nil}
        expect(response.status).to eq 422
      end
    end
  end

  describe "create_mapping" do
    before { controller.instance_variable_set "@map", map }

    it "calls add_geo_data on map" do
      expect(map).to receive(:add_geo_data).with(geo_data).and_return(double(id: nil))
      controller.send :create_mapping, geo_data
    end
    it "returns added message when create mapping" do
      allow(map).to receive(:add_geo_data).with(geo_data).and_return(double(id: 1))
      expect(controller.send(:create_mapping, geo_data)[1]).to eq I18n.t('maps.add_geo_data.added', target: geo_data.name)
    end
    it "returns exists message when create mapping" do
      allow(map).to receive(:add_geo_data).with(geo_data).and_return(double(id: nil))
      expect(controller.send(:create_mapping, geo_data)[1]).to eq I18n.t('maps.add_geo_data.exists', target: geo_data.name)
    end
  end

end
