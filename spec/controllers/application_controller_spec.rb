require 'spec_helper'

describe ApplicationController do
  describe '#set_locale' do
    after(:each) do
      I18n.locale = I18n.default_locale
    end

    it 'gets from user.language' do
      controller.stub_chain(:current_user, :language).and_return :de
      expect(controller.send :set_locale).to eq :de
    end

    it 'gets from session (for annonymous user)' do
      controller.stub(:session).and_return({:language => :ch})
      expect(controller.send :set_locale).to eq :ch
    end

    it 'gets from http header' do
      controller.stub(:extract_from_header).and_return :'pt-BR'
      expect(controller.send :set_locale).to eq :'pt-BR'
    end

    it 'defaults to I18n.default_locale' do
      controller.stub(:extract_from_header).and_return nil
      expect(controller.send :set_locale).to_not be_nil
      expect(controller.send :set_locale).to eq I18n.default_locale
    end
  end

  describe "#search" do
    let!(:map) { FactoryGirl.create :map, name: "Open Data Organizations"}

    before { post :search, {term: "open"}}

    it { expect(response).to render_template 'shared/search_results' }
    it { expect(assigns[:results]).to be_a_kind_of Array }
    it { expect(assigns[:results].first).to eq map }
  end

  describe "#language" do
    before { controller.request.env['HTTP_REFERER'] = "http://test.host/" }

    context "invalid code" do
      before { get :language, :code => code }

      shared_examples_for 'do not set language and redirect back' do
        it { expect(controller.session[:language]).to be_nil }
        it { expect(response).to redirect_to :back }
      end

      context 'nil' do
        let(:code) { '' }
        it_behaves_like 'do not set language and redirect back'
      end

      context 'unavailable code' do
        let(:code) { 'ch' }
        it_behaves_like 'do not set language and redirect back'
      end
    end

    context 'valid code' do
      let(:code) { 'pt-BR' }
      after { controller.session[:language] = nil }

      context 'annonymous user' do
        before { get :language, :code => code }
        it { expect(controller.session[:language]).to eq code }
      end

      context 'logged user' do
        let(:user) { FactoryGirl.create(:user) }

        before do
          login_user user
          get :language, :code => code
        end

        it "saves the language to the user" do
          expect(controller.current_user).to be_a_kind_of User
          expect(user.reload.language).to eq code
          expect(controller.session[:language]).to eq code
        end
      end
    end
  end

  describe "Utils" do
    describe "#set_logged_in_cookie" do
      it "sets cookie" do
        controller.send :set_logged_in_cookie
        expect(controller.send(:cookies)[:logged_in]).to be true
      end
    end

    describe "#destroy_logged_in_cookie" do
      it "deletes cookie" do
        controller.send(:cookies)[:logged_in] = true
        controller.send :destroy_logged_in_cookie
        expect(controller.send(:cookies)[:logged_in]).to be nil
      end
    end

    describe "#login_redirect_path" do
      it "gets from session if has return_to_url set" do
        allow(controller).to receive(:session).and_return({return_to_url: '/return_url'})
        expect(controller.send :login_redirect_path).to eq '/return_url'
      end

      it "removes return_to_url from session" do
        allow(controller).to receive(:session).and_return({return_to_url: '/return_url'})
        expect(controller.send :login_redirect_path).to eq '/return_url'
        expect(controller.send(:session)[:return_to_url]).to be nil
      end

      it "gets from HTTP_REFERER if no return_to_url is set" do
        allow(controller.request).to receive(:env).and_return({'HTTP_REFERER' => '/referer_url'})
        expect(controller.send :login_redirect_path).to eq '/referer_url'
      end

      it "returns root_path if has no return_to_url or referer" do
        expect(controller.send :login_redirect_path).to eq controller.root_path
      end

      it "returns root_path if referer is the login_path" do
        allow(controller.request).to receive(:env).and_return({'HTTP_REFERER' => '/login'})
        expect(controller.send :login_redirect_path).to eq controller.root_path
      end
    end

    describe '#to_bool' do
      it 'gets true from string' do
        expect(controller.send :to_bool, 'true').to be true
        expect(controller.send :to_bool, 't').to be true
        expect(controller.send :to_bool, 'yes').to be true
        expect(controller.send :to_bool, 'y').to be true
        expect(controller.send :to_bool, '1').to be true
      end

      it 'gets false from string' do
        expect(controller.send :to_bool, 'false').to be false
        expect(controller.send :to_bool, 'f').to be false
        expect(controller.send :to_bool, 'no').to be false
        expect(controller.send :to_bool, 'n').to be false
        expect(controller.send :to_bool, '0').to be false
      end

      it 'gets true from true' do
        expect(controller.send :to_bool, true).to be true
      end

      it 'gets false from false' do
        expect(controller.send :to_bool, false).to be false
      end

      it 'gets false from nil' do
        expect(controller.send :to_bool, nil).to be false
      end

      it 'raises exception from invalid string' do
        expect {controller.send :to_bool, 'spam'}.to raise_error(ArgumentError)
      end
    end

    describe "#save_object" do
      let(:geo_data) { FactoryGirl.create :geo_data }
      let(:user) { FactoryGirl.create :user }

      before { controller.stub(:current_user).and_return user }

      it "expects to send updated event to EventBus" do
        expect(EventBus).to receive(:publish).with("geo_data_updated", geo_data: geo_data, current_user: user, changes: anything)
        expect(controller).to receive(:render).with(json: {redirect: controller.geo_data_path(geo_data)})
        controller.send :save_object, geo_data, {name: 'new name'}
      end
    end

    describe "#cleaned_contacts" do
      context 'nil' do
        let(:params) { {contacts: nil} }
        it { expect(controller.send :cleaned_contacts, params).to eq({}) }
      end
      context 'valid hash' do
        let(:params) { {contacts: {address: 'Foo', phone: '12345', compl: ''}} }
        it { expect(controller.send :cleaned_contacts, params).to eq({address: 'Foo', phone: '12345'}) }
      end
    end

    describe "#cleaned_additional_info" do
      context "nil" do
        let(:params) { {additional_info: nil} }
        it { expect(controller.send :cleaned_additional_info, params).to eq nil}
      end
      context "empty string" do
        let(:params) { {additional_info: ""} }
        it { expect(controller.send :cleaned_additional_info, params).to eq nil}
      end
      context "valid yaml" do
        let(:params) { {additional_info: "foo: bar\nbar: baz\n"} }
        it { expect(controller.send :cleaned_additional_info, params).to eq({"foo" => "bar", "bar" => "baz"})}
      end
      context "return unparsed value if invalid yaml" do
        let(:params) { {additional_info: "invalid"} }
        it { expect(controller.send :cleaned_additional_info, params).to eq "invalid" }
      end
    end

    describe "#cleaned_location" do
      context "nil" do
        let(:params) { {location: nil} }
        it { expect(controller.send :cleaned_location, params).to eq nil}
      end
      context "empty string" do
        let(:params) { {location: ""} }
        it { expect(controller.send :cleaned_location, params).to eq nil}
      end
      context "valid geojson" do
        let(:params) { {location: '{"type": "FeatureCollection", "features": [{"type": "Feature", "properties": {}, "geometry": {"type": "Point", "coordinates": [16, 26]}}]}' } }
        it { expect(controller.send(:cleaned_location, params).as_text).to eq "POINT (16.0 26.0)" }
      end
      context "return nil if invalid geojson" do
        let(:params) { {location: '{"type": "FeatureColecton", "features": [{"type": "Feature", "properties": {}, "geomty": {"type": "Point", "coordinates": [16, 26]}}]}' } }
        it { expect(controller.send :cleaned_location, params).to eq nil}
      end
    end

    describe "#find_polymorphic_object" do
      let(:map) { FactoryGirl.create :map }
      it "gets the object from the referer" do
        controller.stub_chain(:request, :path).and_return "/maps/#{map.id}/contributors"
        expect(controller.send :find_polymorphic_object).to eq map
        expect(controller.instance_variable_get "@map").to eq map
      end
    end

    describe "#find_polymorphic_model" do
      it "gets the maps model from the referer" do
        controller.stub_chain(:request, :path).and_return "/maps/bulk_export"
        expect(controller.send :find_polymorphic_model).to eq Map
      end
      it "gets the geo_data model from the referer" do
        controller.stub_chain(:request, :path).and_return "/geo_data/bulk_export"
        expect(controller.send :find_polymorphic_model).to eq GeoData
      end
    end

    describe "#cleaned_tags" do
      context 'default field name' do
        let(:params) { {tags: "foo,bar,baz"} }
        it { expect(controller.send :cleaned_tags, params).to eq ["foo", "bar", "baz"]}
      end
      context 'other field name' do
        let(:params) { {interests: "foo,bar,baz"} }
        it { expect(controller.send :cleaned_tags, params, :interests).to eq ["foo", "bar", "baz"]}
      end
      context 'nil' do
        let(:params) { {tags: nil} }
        it { expect(controller.send :cleaned_tags, params).to eq []}
      end
    end

    describe "#cleaned_relations_attributes" do
      let(:cleaned) { controller.send :cleaned_relations_attributes, params }
      let(:rel) { cleaned.first }
      before { allow(controller).to receive(:cleaned_relation_metadata).and_return({}) }

      describe "defaults" do
        let(:params) { {relations_attributes: [{id: "", target: {id: ""}, type: "", metadata: {} }].to_json} }

        it "expect to return array of open Structs" do
          expect(cleaned).to be_a_kind_of Array
          expect(rel).to be_a_kind_of OpenStruct
        end

        it { expect(rel.id).to be nil }
        it { expect(rel.target).to be nil }
        it { expect(rel.direction).to be nil }
      end

      describe "parse" do
        let(:params) { {relations_attributes: [{id: "2", target: {id: "42"}, type: "support_dir", metadata: {} }].to_json} }

        it "expect to return array of open Structs" do
          expect(cleaned).to be_a_kind_of Array
          expect(rel).to be_a_kind_of OpenStruct
        end

        it { expect(rel.id).to eq 2 }
        it { expect(rel.target).to eq 42 }
        it { expect(rel.direction).to eq 'dir' }
        it { expect(rel.rel_type).to eq 'support' }
      end
    end

    describe "#cleaned_relation_metadata" do
      let(:cleaned) { controller.send :cleaned_relation_metadata, params }

      describe "defaults" do
        let(:params) { {description: "  ", start_date: "", end_date: "", currency: "usd", amount: "" }.with_indifferent_access }

        it { expect(cleaned).to be_a_kind_of OpenStruct }

        it { expect(cleaned.description).to be nil }
        it { expect(cleaned.start_date).to be nil }
        it { expect(cleaned.end_date).to be nil }
        it { expect(cleaned.currency).to be nil }
        it { expect(cleaned.amount).to be nil }
      end

      describe "parse" do
        let(:params) { {description: "bla", start_date: "2014-08-7", end_date: "2014-08-10", currency: "brl", amount: "14000.00" }.with_indifferent_access }

        it { expect(cleaned).to be_a_kind_of OpenStruct }

        it { expect(cleaned.description).to eq 'bla' }
        it { expect(cleaned.start_date).to eq Date.new(2014, 8, 7) }
        it { expect(cleaned.end_date).to eq Date.new(2014, 8, 10) }
        it { expect(cleaned.currency).to eq "brl" }
        it { expect(cleaned.amount).to eq 14000.00 }
      end
    end

    describe "#flash_xhr" do
      it "renders alerts partial" do
        expect(controller).to receive(:render_to_string).with(partial: 'shared/alerts')
        controller.send :flash_xhr, "message"
      end
    end
  end

end
