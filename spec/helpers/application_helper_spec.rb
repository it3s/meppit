require 'spec_helper'

describe ApplicationHelper do

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
end
