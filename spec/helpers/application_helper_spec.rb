require 'spec_helper'

describe ApplicationHelper do

  describe "#javascript_exists?" do
    it { expect(helper.javascript_exists?('application')).to be true }
    it { expect(helper.javascript_exists?('inexistent')).to be false}
  end

  describe "#with_http" do
    it { expect(helper.with_http "http://www.meppit.com").to eq "http://www.meppit.com"}
    it { expect(helper.with_http "www.meppit.com").to eq "http://www.meppit.com"}
  end

  describe "#object_type" do
    let(:user) { FactoryGirl.create :user }
    let(:geo_data) { FactoryGirl.create :geo_data }
    let(:map) { FactoryGirl.create :map }
    it { expect(helper.object_type user).to eq :user }
    it { expect(helper.object_type geo_data).to eq :geo_data }
    it { expect(helper.object_type map).to eq :map }
    it { expect(helper.object_type nil).to eq :unknown }
  end

  describe "#menu_active?" do
    it "returns true for same controller" do
      helper.stub(:params).and_return({controller: 'geo_data'})
      expect(helper.menu_active? 'geo_data').to be_truthy
    end

    it "returns false for other controller" do
      helper.stub(:params).and_return({controller: 'users'})
      expect(helper.menu_active? 'geo_data').to be_falsey
    end

    it "true for another controller but with object ref" do
      helper.stub(:params).and_return({controller: 'users', map_id: 2})
      expect(helper.menu_active? 'maps').to be_truthy
    end

    it "false for another controller without object ref" do
      helper.stub(:params).and_return({controller: 'users', map_id: nil})
      expect(helper.menu_active? 'maps').to be_falsey
    end
  end

  describe "#edit_mode?" do
    it "returns true if action is edit" do
      helper.stub(:params).and_return(action: 'edit')
      expect(helper.edit_mode?).to be true
    end
    it "returns true if action is edit" do
      helper.stub(:params).and_return(action: 'new')
      expect(helper.edit_mode?).to be true
    end
    it "returns false if any other action than edit or new" do
      helper.stub(:params).and_return(action: 'show')
      expect(helper.edit_mode?).to be false
    end
  end

  describe "#identifier_for" do
    let(:user) { FactoryGirl.create :user, id: 42 }
    let(:geo_data) { FactoryGirl.create :geo_data, id: 42 }
    let(:map) { FactoryGirl.create :map, id: 42 }

    it "returns different values for different objects with the same id" do
      user_identifier = helper.identifier_for user
      geo_data_identifier = helper.identifier_for geo_data
      map_identifier = helper.identifier_for map
      expect(user_identifier).to_not eq geo_data_identifier
      expect(user_identifier).to_not eq map_identifier
      expect(map_identifier).to_not eq geo_data_identifier
    end

    it "returns the same value if called twice" do
      user_identifier = helper.identifier_for user
      expect(user_identifier).to eq helper.identifier_for(user)
    end
  end

  describe "#follow_options_for" do
    let(:user) { FactoryGirl.create :user}
    let(:geo_data) { FactoryGirl.create :geo_data}

    before { allow(helper).to receive(:current_user).and_return user }

    it "returns a json" do
      resp = helper.follow_options_for geo_data
      expect(resp).to be_a String
      expect{JSON.parse resp}.to_not raise_error
    end
  end

  describe "#collection_location" do
    let(:geom1) { RGeo::Cartesian.simple_factory.parse_wkt "GEOMETRYCOLLECTION (POINT (-10.000 -10.000))" }
    let(:geo_data1) { FactoryGirl.create(:geo_data, location: geom1) }
    let(:geom2) { RGeo::Cartesian.simple_factory.parse_wkt "GEOMETRYCOLLECTION (POINT (-20.000 -20.000))" }
    let(:geo_data2) { FactoryGirl.create(:geo_data, location: geom2) }
    let(:map) { FactoryGirl.create :map }
    let(:geojson1) {
      {
        "type"=>"Feature",
        "geometry"=>{
          "type"=>"GeometryCollection",
          "geometries"=>[{"type"=>"Point", "coordinates"=>[-10.0, -10.0]}]
        },
        "properties"=> geo_data1.geojson_properties.stringify_keys,
        "id"=>geo_data1.id
      }.to_json
    }
    let(:geojson2) {
      {
        "type"=>"Feature",
        "geometry"=>{
          "type"=>"GeometryCollection",
          "geometries"=>[{"type"=>"Point", "coordinates"=>[-20.0, -20.0]}]
        },
        "properties"=> geo_data2.geojson_properties.stringify_keys,
        "id"=>geo_data2.id
      }.to_json
    }

    before {
      map.add_geo_data geo_data1
    }

    it { expect(helper.collection_location([map, geo_data2])).to be_a_kind_of OpenStruct }
    it { expect(helper.collection_location([map, geo_data2]).location_geojson).to include geojson1 }
    it { expect(helper.collection_location([map, geo_data2]).location_geojson).to include geojson2 }
  end

  describe "Concerns::I18nHelper" do
    describe "#i18n_language_names" do
      it 'has names for all availables locales' do
        I18n.available_locales.each do |locale|
          name = helper.i18n_language_names[locale]
          expect(name).to_not be_nil
          expect(name).to be_a_kind_of String
        end
      end

      it { expect(helper.i18n_language_names[:en]).to eq 'English' }
      it { expect(helper.i18n_language_names[:'pt-BR']).to eq 'Português' }
    end

    describe "#current_translations" do
      it 'retrieves the translations hash for the locale' do
        translations = helper.current_translations
        expect(translations).to be_a_kind_of Hash
        expect(translations).to eq I18n.backend.send(:translations)[:en].with_indifferent_access
      end
    end
  end

  describe "Concerns::ContactsHelper" do
    let(:user) { FactoryGirl.create :user, :contacts => {'address' => 'rua Bla', 'phone' => '12345'} }

    describe "#contacts_list_for" do
      it 'returns an empty list for nil contacts' do
        user.contacts = nil
        expect(helper.contacts_list_for user).to eq []
      end

      it 'selects only the icons forms existing contact keys' do
        expect(helper.contacts_list_for user).to eq([
          {:key => 'phone',   :icon => :phone, :value => "12345"},
          {:key => 'address', :icon => :home,  :value => "rua Bla"},
        ])
      end
    end

    describe "#contacts_fields_for" do
      it "builds fields for all contacts" do
        expect(helper.contacts_fields_for(user).size).to eq 10
      end

      it "build fields even if contacts is nil" do
        user.contacts = nil
        expect(helper.contacts_fields_for(user).size).to eq 10
      end

      it "each contact field has key, icon, value and name" do
        expect(helper.contacts_fields_for(user).first.keys).to eq [:key, :icon, :value, :name]
      end
    end
  end

  describe "#export_path_for" do
    let(:geo_data) { FactoryGirl.create :geo_data }
    let(:map) { FactoryGirl.create :map }

    it { expect(helper.export_path_for(geo_data, :json)).to eq helper.export_geo_data_path(geo_data, format: :json) }
    it { expect(helper.export_path_for(map, :json)).to eq helper.export_map_path(map, format: :json) }

    it "generate path for bluk export on geo_data" do
      allow(helper).to receive(:controller_name).and_return 'geo_data'
      expect(helper.export_path_for nil, :json).to eq helper.bulk_export_geo_data_index_path(format: :json)
    end

    it "generate path for bluk export on maps" do
      allow(helper).to receive(:controller_name).and_return 'maps'
      expect(helper.export_path_for nil, :json).to eq helper.bulk_export_maps_path(format: :json)
    end
  end

  describe "Concerns::ComponentsHelper" do
    describe "#hash_to_attributes" do
      it "return empty string for empty hash" do
        expect(helper.hash_to_attributes({})).to eq ''
      end

      it "converts sigle key hashes" do
        hash = {:aaa => "bbb"}
        attrs = 'aaa="bbb"'
        expect(helper.hash_to_attributes hash ).to eq attrs
      end

      it "converts multi keys hashes" do
        hash = {:id => "some-id", :class => "cls1 cls2"}
        attrs = 'id="some-id" class="cls1 cls2"'
        expect(helper.hash_to_attributes hash ).to eq attrs
      end
    end

    describe "#link_to_modal" do
      context "regular modal" do
        let(:anchor) { '<a href="#some-id" class="button" data-components="modal" data-modal-options=\'{}\'>Open Modal</a>' }
        it "renders modal component" do
          expect(helper.link_to_modal 'Open Modal', '#some-id', :html => { :class => 'button'} ).to eq anchor
        end
      end

      context "remote modal" do
        let(:link) { helper.link_to_modal 'Open Modal', '#some-id', :remote => true }
        it { expect(link).to include 'data-modal-options=\'{"remote":true}\'' }
      end

      context "autoload and prevent_close" do
        let(:link) { helper.link_to_modal 'Open Modal', '#some-id', :autoload => true, :prevent_close => true }
        it { expect(link).to include 'data-modal-options=\'{"autoload":true,"prevent_close":true}\'' }
      end

    end

    describe "#link_to_tooltip" do
      let(:anchor) { '<a href="#tpl" data-components="tooltip" data-tooltip-options=\'{"template":"#tpl"}\'>Open</a>' }
      it "renders tooltip component" do
        expect(helper.link_to_tooltip 'Open', '#tpl').to eq anchor
      end
    end

    describe "#remote_form_for" do
      let(:user) { FactoryGirl.build(:user) }

      context "without options" do
        let(:args) { {:remote => true, :html => {'data-components' => 'remoteForm', 'multipart' => true}} }
        let(:form) { "" }
        it "class simple_form_for with remote options" do
          helper.should receive(:simple_form_for).with(user, args)
          helper.remote_form_for user { }
        end
      end

      context "with extra options" do
        let(:args) { {:remote => true, :other => :bla, :html => {'data-components' => 'remoteForm', 'multipart' => true, :class => 'my-class'}} }
        let(:form) { "" }
        it "class simple_form_for with remote options" do
          helper.should receive(:simple_form_for).with(user, args)
          helper.remote_form_for user, :other => :bla, :html => {:class => 'my-class'} { }
        end
      end
    end

    describe "#tags_input" do
      let(:obj) { FactoryGirl.create :user, :interests => ['aa', 'bb'] }
      let(:input) { '<input class="string optional" data-components="tags" data-tags-options=\'{"tags":["aa","bb"],"autocomplete":"/tags/search"}\' id="user_interests" name="user[interests]" type="text" value=\'["aa","bb"]\' />' }

      it "render tags inputs" do
        helper.simple_form_for(obj) do |f|
          generated = helper.tags_input(f, :interests, ['aa', 'bb'])
          escaped_options = CGI::escapeHTML('"tags":["aa","bb"],"autocomplete":"/tags/search"')
          expect(generated.include? 'data-components="tags"').to be true
          expect(generated.include? "data-tags-options=\"{#{escaped_options}}\"").to be true
          expect(generated.include? 'name="user[interests]"').to be true
        end
      end
    end

    describe "#autocomplete_field_tag" do
      let(:rendered) { <<-HTML
<input id="map-autocomplete" name="map" type="hidden" value="" />
<input data-autocomplete-options="{&quot;name&quot;:&quot;map&quot;,&quot;url&quot;:&quot;/fake-url&quot;}" data-components="autocomplete" id="map_autocomplete" name="map_autocomplete" placeholder="search by map name" type="text" value="" />
HTML
      }

      it "calls render on the autocomplete partial" do
        expect(helper).to receive(:render
          ).with("shared/components/autocomplete", name: "test", url: "/fake-url"
          ).and_return("")
        helper.autocomplete_field_tag("test", "/fake-url")
      end

      it "generates component's markup" do
        expect(helper.autocomplete_field_tag "map", "/fake-url" ).to eq rendered
      end
    end

    describe "#additional_info_value" do
      context "nil" do
        let(:f) { double(object: double(additional_info: nil)) }
        it { expect(helper.additional_info_value(f)).to eq "" }
      end
      context "empty hash" do
        let(:f) { double(object: double(additional_info: {})) }
        it { expect(helper.additional_info_value(f)).to eq "" }
      end
      context "hash" do
        let(:f) { double(object: double(additional_info: {"foo" => "bar"})) }
        it { expect(helper.additional_info_value(f)).to eq "foo: bar\n" }
      end
    end

    describe "#additional_info_json" do
      context "empty hash" do
        let(:obj) { double(additional_info: {}) }
        it { expect(helper.additional_info_json(obj)).to eq '{"jsonData":{}}' }
      end
      context "nested hash" do
        let(:obj) { double(additional_info: {"foo" => "bar", "bar" => {"number" => 42}}) }
        it { expect(helper.additional_info_json(obj)).to eq('{"jsonData":{"Foo":"bar","Bar":{"Number":42}}}') }
      end
    end

    describe "#_hash_with_humanized_keys" do
      let(:hash) { {"some_string" => "bla"} }
      it { expect(helper.send :_hash_with_humanized_keys, hash).to eq({"Some string" => "bla"}) }
    end

    describe "#_nested_hash_value" do
      it { expect(helper.send :_nested_hash_value, 42).to eq 42 }
      it "calls _hash_with_humanized_keys when value is Hash" do
        expect(helper).to receive(:_hash_with_humanized_keys).with({foo: 42})
        helper.send :_nested_hash_value, {foo: 42}
      end
    end

    describe "#relations_manager_data" do
      it "expects all required keys to be present" do
        keys = [:options, :autocomplete_placeholder, :autocomplete_url, :remove_title,
                :metadata_title, :start_date_label, :end_date_label, :amount_label]
        expect(helper.relations_manager_data.keys).to eq keys
      end
    end

    describe "#show_relation_metadata" do
      it "retuns false for empty" do
        rel = {metadata: {}}
        expect(helper.show_relation_metadata?(rel)).to be false
      end
      it "returns false is all values are blank" do
        rel = {metadata: {description: "", start_date: "", amount: nil}}
        expect(helper.show_relation_metadata?(rel)).to be false
      end
      it "returns true otherwise" do
        rel = {metadata: {description: "blaa", start_date: nil}}
        expect(helper.show_relation_metadata?(rel)).to be true
      end
    end

    describe "#currency_symbol" do
      it { expect(helper.currency_symbol('eur')).to eq helper.icon('euro') }
      it { expect(helper.currency_symbol('usd')).to eq helper.icon('dollar') }
      it { expect(helper.currency_symbol('brl')).to eq "R$" }
      it { expect(helper.currency_symbol('')).to eq "$" }
    end
  end
end
