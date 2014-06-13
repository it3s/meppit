require 'spec_helper'

describe ApplicationHelper do

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

  describe "#javascript_exists?" do
    it { expect(helper.javascript_exists?('application')).to be_true }
    it { expect(helper.javascript_exists?('inexistent')).to be_false}
  end

  describe "#with_http" do
    it { expect(helper.with_http "http://www.meppit.com").to eq "http://www.meppit.com"}
    it { expect(helper.with_http "www.meppit.com").to eq "http://www.meppit.com"}
  end

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
      let(:anchor) { '<a href="#some-id" class="button" data-components="modal" data-modal=\'{}\'>Open Modal</a>' }
      it "renders modal component" do
        expect(helper.link_to_modal 'Open Modal', '#some-id', :html => { :class => 'button'} ).to eq anchor
      end
    end

    context "remote modal" do
      let(:link) { helper.link_to_modal 'Open Modal', '#some-id', :remote => true }
      it { expect(link).to include 'data-modal=\'{"remote":true}\'' }
    end

    context "autoload and prevent_close" do
      let(:link) { helper.link_to_modal 'Open Modal', '#some-id', :autoload => true, :prevent_close => true }
      it { expect(link).to include 'data-modal=\'{"autoload":true,"prevent_close":true}\'' }
    end

  end

  describe "#link_to_tooltip" do
    let(:anchor) { '<a href="#" data-components="tooltip" data-tooltip=\'{"template":"#tpl"}\'>Open</a>' }
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
    let(:input) { '<input class="string optional" data-autocomplete="/tags/search" data-components="tags" data-tags=\'["aa","bb"]\' id="user_interests" name="user[interests]" type="text" value=\'["aa","bb"]\' />' }

    it "render tags inputs" do
      helper.simple_form_for(obj) do |f|
        generated = helper.tags_input(f, :interests, ['aa', 'bb'])
        expect(generated.include? 'data-components="tags"').to be_true
        expect(generated.include? 'data-tags="[&quot;aa&quot;,&quot;bb&quot;]"').to be_true
        expect(generated.include? 'name="user[interests]"').to be_true
        expect(generated.include? "data-autocomplete=\"#{helper.tag_search_path}\"").to be_true
      end
    end
  end

  describe "#tools_list" do
    let(:obj) { FactoryGirl.create :user }
    before { helper.stub(:current_user).and_return obj }
    it { expect(helper.tools_list(obj).size).to eq 7 }
    it { expect(helper.tools_list(obj, only=[:edit, :star]).size).to eq 2 }
  end

  describe "#counters_list" do
    let(:obj) { FactoryGirl.create :user }
    it { expect(helper.counters_list(obj).size).to eq 2 }
    it { expect(helper.counters_list(obj, only=[:map]).size).to eq 1 }
  end

  describe "#object_type" do
    let(:user) { FactoryGirl.create :user }
    let(:geo_data) { FactoryGirl.create :geo_data }
    it { expect(helper.object_type user).to eq :user }
    it { expect(helper.object_type geo_data).to eq :data }
    it { expect(helper.object_type nil).to eq :unknown }
  end

  describe "Corcerns::ContactsHelper" do
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

end
