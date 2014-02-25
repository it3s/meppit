require 'spec_helper'

describe ApplicationHelper do

  describe "#javascript_exists?" do
    it { expect(helper.javascript_exists?('application')).to be_true }
    it { expect(helper.javascript_exists?('inexistent')).to be_false}
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

  describe "#remote_form_for" do
    let(:user) { FactoryGirl.build(:user) }

    context "without options" do
      let(:args) { {:remote => true, :html => {'data-components' => 'remoteForm'}} }
      let(:form) { "" }
      it "class simple_form_for with remote options" do
        helper.should receive(:simple_form_for).with(user, args)
        helper.remote_form_for user { }
      end
    end

    context "with extra options" do
      let(:args) { {:remote => true, :other => :bla, :html => {'data-components' => 'remoteForm', :class => 'my-class'}} }
      let(:form) { "" }
      it "class simple_form_for with remote options" do
        helper.should receive(:simple_form_for).with(user, args)
        helper.remote_form_for user, :other => :bla, :html => {:class => 'my-class'} { }
      end
    end
  end

end
