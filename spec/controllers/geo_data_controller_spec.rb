require 'spec_helper'

describe GeoDataController do
  let(:geo_data) { FactoryGirl.create :geo_data }
  let(:map)      { FactoryGirl.create :map }
  let(:user)     { FactoryGirl.create :user }

  describe "GET index" do
    context "regular request" do
      it 'calls object_collection filter' do
        controller.stub(:object_collection).and_call_original
        controller.should_receive :object_collection
        get :index
      end

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

    describe "list filter" do
      let(:geoms) do
        [[10, 10], [20, 10],  [30, 10], [40, 10]
        ].collect { |lon, lat| RGeo::Cartesian.simple_factory.parse_wkt "POINT (#{lon} #{lat})"  }
      end
      before do
        [['b', geoms[1]], ['c', geoms[2]], ['a', geoms[0]], ['d', geoms[3]]
      ].each { |n, l| FactoryGirl.create :geo_data, name: n, location: l, tags:['z', n] }
      end

      describe "filter by tags" do
        it "contains one tag" do
          get :index, list_filter: {tags: 'a', tags_type: 'all'}
          expect((assigns :geo_data_collection).map(&:name)).to match_array ['a']
        end

        it "contains two tags" do
          get :index, list_filter: {tags: 'z,b', tags_type: 'all'}
          expect((assigns :geo_data_collection).map(&:name)).to match_array ['b']
        end

        it "contains at least one tag" do
          get :index, list_filter: {tags: 'b,c', tags_type: 'any'}
          expect((assigns :geo_data_collection).map(&:name)).to match_array ['b', 'c']
        end
      end

      describe "sort by location" do
        it "uses distance from (5, 10)" do
          get :index, list_filter: {sort_by: 'location', longitude: 5, latitude: 10}
          expect((assigns :geo_data_collection).map(&:name)).to eq ['a', 'b', 'c', 'd']
        end
        it "uses distance from (18, 10)" do
          get :index, list_filter: {sort_by: 'location', longitude: 18, latitude: 10}
          expect((assigns :geo_data_collection).map(&:name)).to eq ['b', 'a', 'c', 'd']
        end
        it "uses distance from (50, 10)" do
          get :index, list_filter: {sort_by: 'location', longitude: 50, latitude: 10}
          expect((assigns :geo_data_collection).map(&:name)).to eq ['d', 'c', 'b', 'a']
        end
      end

      describe "sort by name" do
        context "asc" do
          it do
            get :index, list_filter: {sort_by: 'name', order: 'asc'}
            expect((assigns :geo_data_collection).map(&:name)).to eq ['a', 'b', 'c', 'd']
          end
        end
        context "desc" do
          it do
            get :index, list_filter: {sort_by: 'name', order: 'desc'}
            expect((assigns :geo_data_collection).map(&:name)).to eq ['d', 'c', 'b', 'a']
          end
        end
      end

      describe "sort by date" do
        context "asc" do
          it do
            get :index, list_filter: {sort_by: 'created_at', order: 'asc'}
            expect((assigns :geo_data_collection).map(&:name)).to eq ['b', 'c', 'a', 'd']
          end
        end
        context "desc" do
          it do
            get :index, list_filter: {sort_by: 'created_at', order: 'desc'}
            expect((assigns :geo_data_collection).map(&:name)).to eq ['d', 'a', 'c', 'b']
          end
        end
      end
    end
  end

  describe "GET show" do
    it 'calls find_object filter' do
      controller.should_receive :find_object
      get :show, {:id => geo_data.id}
    end

    it 'sets geo_data and render template' do
      get :show, {:id => geo_data.id}
      expect(assigns :geo_data).to eq geo_data
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
        expect(assigns :geo_data).to be_a_kind_of GeoData
        expect(response).to render_template :new
      end
    end
  end


  describe "POST create" do
    let(:geo_data_params) { {:description => "<h2>Test</h2> <p>save html text</p>",
                             :name => "new geo_data"} }

    before { login_user user }

    it 'saves geo_data and return redirect' do
      post :create, {:geo_data => geo_data_params}
      expect(assigns :geo_data).to be_a_kind_of GeoData
      expect(response.body).to match({:redirect => geo_data_path(assigns :geo_data)}.to_json)
    end

    it "publishes geo_data_updated to EventBus" do
      expect(EventBus).to receive(:publish).with("geo_data_created", anything)
      post :create, {:geo_data => geo_data_params}
    end

    it 'validates model and returns errors' do
      post :create, {:geo_data => geo_data_params.merge!(:name => "")}
      expect(assigns :geo_data).to be_a_kind_of GeoData
      expect(response.body).to eq({:errors => {:name => [controller.t('activerecord.errors.messages.blank')]}}.to_json)
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

      it 'calls find_object filter' do
        controller.should_receive :find_object
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

    it "publishes geo_data_updated to EventBus" do
      expect(EventBus).to receive(:publish).with("geo_data_updated", anything)
      post :update, {:id => geo_data.id, :geo_data => data_params}
    end

    it 'validates model and returns errors' do
      post :update, {:id => geo_data.id, :geo_data => data_params.merge!(:name => "")}
      expect(assigns :geo_data).to eq geo_data
      expect(response.body).to eq({:errors => {:name => [controller.t('activerecord.errors.messages.blank')]}}.to_json)
    end

    describe "validates additional_info yaml format" do
      context "valid for empty" do
        let(:yaml) { "" }
        before { post :update, {id: geo_data.id, geo_data: data_params.merge(additional_info: yaml)} }
        it { expect(response.status).to eq 200 }
      end
      context "valid for hash" do
        let(:yaml) { "foo: bar\n" }
        before { post :update, {id: geo_data.id, geo_data: data_params.merge(additional_info: yaml)} }
        it { expect(response.status).to eq 200 }
      end
      context "invalid for others" do
        let(:yaml) { "invalid string" }
        before { post :update, {id: geo_data.id, geo_data: data_params.merge(additional_info: yaml)} }
        it { expect(response.status).to eq 422 }
        it { expect(response.body).to eq({errors: {additional_info: [I18n.t('additional_info.invalid')]}}.to_json) }
      end
    end

    describe "save relations and metadata" do
      let(:related) { FactoryGirl.create :geo_data }
      let(:relation_params) {
        { relations_attributes: [{
          id: "2", target: {id: related.id.to_s}, type: "support_dir",
          metadata: {description: "bla", start_date: "2014-08-7", end_date: "2014-08-10", currency: "brl", amount: "14000.00" }
        }].to_json}
      }

      it "saves properly" do
        post :update, {:id => geo_data.id, :geo_data => data_params.merge(relation_params)}
        expect(assigns :geo_data).to eq geo_data
        expect(response.body).to match({:redirect => geo_data_path(geo_data)}.to_json)

        geo_data.reload
        values = geo_data.relations_values.first

        expect(values[:target]).to eq({id: related.id, name: related.name })
        expect(values[:type]).to eq 'support_dir'
        expect(values[:metadata]).to eq({
          "description" => 'bla',
          "start_date"  => Date.new(2014, 8, 7),
          "end_date"    => Date.new(2014, 8, 10),
          "currency"    => 'brl',
          "amount"      => 14000.00,
        })
      end

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

  describe "POST add_map" do
    before { login_user user }

    context "success" do
      before { post :add_map, {id: geo_data.id, map: map.id} }
      it { expect(response.body).to eq({flash: "", count: 1}.to_json) }
    end

    context "failure" do
      it "returns invalid message" do
        expect(controller).to receive(:flash_xhr).with I18n.t('geo_data.add_map.invalid')
        post :add_map, {id: geo_data.id, map: nil}
        expect(response.status).to eq 422
      end
    end
  end

  describe "POST bulk_add_map" do
    let(:map) { FactoryGirl.create :map }
    before { login_user user }

    context "invalid map" do
      let(:params) { {map: "", geo_data_ids: ""} }

      it "returns unprocessable_entity with error message " do
        expect(controller).to receive(:flash_xhr).with(
          I18n.t "geo_data.add_map.invalid").and_return ""
        post :bulk_add_map, params
        expect(response.status).to eq 422
      end
    end

    context "valid map and empty geo_data_ids" do
      let(:params) { {map: map.id, geo_data_ids: ""} }

      it "returns unprocessable_entity with error message " do
        expect(controller).to receive(:flash_xhr).with(
          I18n.t "geo_data.bulk_add_map.empty_selection").and_return ""
        post :bulk_add_map, params
        expect(response.status).to eq 422
      end
    end

    context "valid map and empty geo_data_ids" do
      let(:params) { {map: map.id, geo_data_ids: "1,2,3"} }
      before { 3.times { |i| FactoryGirl.create :geo_data, id: i+1 } }

      it "returns unprocessable_entity with error message " do
        expect(map.mappings.count).to eq 0
        expect(controller).to receive(:flash_xhr).with(
          I18n.t('geo_data.bulk_add_map.added', count: 3, name: map.name)).and_return ""
        post :bulk_add_map, params
        expect(response.status).to eq 200
        expect(map.mappings.count).to eq 3
      end
    end

  end

  describe "create_mapping" do
    before { controller.instance_variable_set "@geo_data", geo_data }

    it "calls add_map on geo_data" do
      expect(geo_data).to receive(:add_map).with(map).and_return(double(id: nil))
      controller.send :create_mapping, map
    end
    it "returns added message when create mapping" do
      allow(geo_data).to receive(:add_map).with(map).and_return(double(id: 1))
      expect(controller.send(:create_mapping, map)[1]).to eq I18n.t('geo_data.add_map.added', target: map.name)
    end
    it "returns exists message when create mapping" do
      allow(geo_data).to receive(:add_map).with(map).and_return(double(id: nil))
      expect(controller.send(:create_mapping, map)[1]).to eq I18n.t('geo_data.add_map.exists', target: map.name)
    end
  end

  describe "GET tile" do
    let(:geoms) do
      [[10, 10], [20, 10],  [30, 10], [40, 10]
      ].collect { |lon, lat| RGeo::Cartesian.simple_factory.parse_wkt "POINT (#{lon} #{lat})"  }
    end
    before do
      [['b', geoms[1]], ['c', geoms[2]], ['a', geoms[0]], ['d', geoms[3]]
    ].each { |n, l| FactoryGirl.create :geo_data, name: n, location: l, tags: ['z', n] }
    end

    it 'calls object_collection filter' do
      controller.stub(:object_collection).and_call_original
      controller.should_receive :object_collection
      get :tile, zoom: 4, x: 9, y: 7
    end

    it 'gets only the objects that intersects the tile' do
      get :tile, zoom: 4, x: 9, y: 7
      expect((assigns :geo_data_collection).map(&:name)).to match_array ['c', 'd']
    end

    describe "filter by tags" do
      it "contains one tag" do
        get :tile, zoom: 4, x: 8, y: 7, list_filter: {tags: 'a', tags_type: 'all'}
        expect((assigns :geo_data_collection).map(&:name)).to match_array ['a']
      end

      it "contains two tags" do
        get :tile, zoom: 4, x: 8, y: 7, list_filter: {tags: 'z,b', tags_type: 'all'}
        expect((assigns :geo_data_collection).map(&:name)).to match_array ['b']
      end

      it "contains at least one tag" do
        get :tile, zoom: 4, x: 8, y: 7, list_filter: {tags: 'z,b', tags_type: 'any'}
        expect((assigns :geo_data_collection).map(&:name)).to match_array ['a', 'b']
      end
    end
  end
end
