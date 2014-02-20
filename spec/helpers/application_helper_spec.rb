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
    context ":remote => false" do
      let(:anchor) { '<a href="#some-id" data-modal="open" class="button" >Open Modal</a>' }

      it "renders anchor tag with data-modal='open'" do
        expect(helper.link_to_modal 'Open Modal', '#some-id', :class => 'button' ).to eq anchor
      end
    end

    context ":remote => false" do
      let(:anchor) { '<a href="/ajax_url.json" rel="modal:open" class="button" >Open Modal</a>' }

      it "renders anchor tag with rel='modal:open'" do
        expect(helper.link_to_modal 'Open Modal', '/ajax_url.json', :class => 'button', :remote => true ).to eq anchor
      end
    end

  end
end
