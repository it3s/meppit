require 'spec_helper'

describe DiffPresenter do
  let(:ctx) { ApplicationController.new.view_context }
  let(:presenter) { DiffPresenter.new items: {key => vals}, ctx: ctx }

  def quoted(v); "&quot;#{v}&quot;" end

  context "string" do
    let(:key)  { :name }
    let(:vals) { OpenStruct.new before: 'old name', after: 'new name' }
    let(:diff) { '<del class="differ">old</del><ins class="differ">new</ins> name' }

    it "show calls _string_diff" do
      expect(presenter).to receive(:_string_diff).with(vals).and_return ''
      presenter.show key, vals
    end

    it "_string_diff does a diff_by_word" do
      expect(presenter.send :_string_diff, vals).to eq diff
    end
  end

  context "text" do
    let(:key)  { :description }
    let(:vals) { OpenStruct.new before: '', after: 'hi' }
    let(:diff) { '<ins class="differ">hi</ins>' }

    it "show calls _text_diff" do
      expect(presenter).to receive(:_text_diff).with(vals).and_return ''
      presenter.show key, vals
    end

    it "_text_diff does a diff_by_line" do
      expect(presenter.send :_text_diff, vals).to eq diff
    end
  end

  context "tags" do
    let(:key)  { :tags }
    let(:vals) { OpenStruct.new before: ["a", "b"], after: ["b", "c"] }
    let(:diff) { '<div class="tags"><span class=\'tag del\'><i class="fa fa-tag"></i> a</span><span class=\'tag \'><i class="fa fa-tag"></i> b</span><span class=\'tag ins\'><i class="fa fa-tag"></i> c</span></div>' }

    it "show calls _tags_diff" do
      expect(presenter).to receive(:_tags_diff).with(vals).and_return ''
      presenter.show key, vals
    end

    it "_tags_diff compare each tag" do
      expect(presenter.send :_tags_diff, vals).to eq diff
    end

    describe "_tag_class" do
      it "returns ins for included tags" do
        expect(presenter.send :_tag_class, "c", vals).to eq 'ins'
      end
      it "returns del for included tags" do
        expect(presenter.send :_tag_class, "a", vals).to eq 'del'
      end
      it "returns empty string for tags that remained the same" do
        expect(presenter.send :_tag_class, "b", vals).to eq ''
      end
    end
  end

  context "contacts" do
    let(:key)  { :contacts }
    let(:vals) { OpenStruct.new before: {a: "1", b: "1", c: "1"}, after: {b:"1", c: "2", d: "3"} }

    it "show calls _contacts_diff" do
      expect(presenter).to receive(:_contacts_diff).with(vals).and_return ''
      presenter.show key, vals
    end

    it "_contacts_diff render contacts view" do
      expect(presenter.ctx).to receive(:render).with('shared/contacts/view', anything)
      presenter.send :_contacts_diff, vals
    end

    describe "_contact_value" do
      it "return ins tag for inserted value" do
        expect(presenter.send :_contact_value, :d, vals).to eq "<ins class='differ'>3</ins>"
      end
      it "return del tag for inserted value" do
        expect(presenter.send :_contact_value, :a, vals).to eq "<del class='differ'>1</del>"
      end
      it "returns the same if not changed" do
        expect(presenter.send :_contact_value, :b, vals).to eq "1"
      end
      it "returns del and ins tags for the older a newer values respectivelly" do
        expect(presenter.send :_contact_value, :c, vals).to eq "<del class='differ'>1</del><ins class='differ'>2</ins>"
      end
    end
  end

  context "jsontable" do
    let(:key)  { :additional_info }
    let(:vals) { OpenStruct.new before: {}, after: {} }
    let(:diff) { '' }

    it "show calls _jsontable_diff" do
      expect(presenter).to receive(:_jsontable_diff).with(vals).and_return ''
      presenter.show key, vals
    end

    it "_jsontable_diff renders versions/jsontable_diff" do
      expect(presenter.ctx).to receive(:render).with('versions/jsontable_diff', vals: vals)
      presenter.send :_jsontable_diff, vals
    end
  end

  context "location" do
    let(:key)  { :location }
    let(:vals) { OpenStruct.new before: {}, after: {"wkt" => "GeometryCollection (Point (-10.0 -10.0))"} }

    it "show calls _location_diff" do
      expect(presenter).to receive(:_location_diff).with(vals).and_return ''
      presenter.show key, vals
    end

    it "_location_diff render versions/location_diff" do
      expect(presenter.ctx).to receive(:render).with('versions/location_diff', anything)
      presenter.send :_location_diff, vals
    end

    describe "_parse_location" do
      it "builds a GeoData with nil location if no wkt provided" do
        expect(::GeoData).to receive(:new).with(location: nil)
        presenter.send :_parse_location, vals, :before
      end
      it "buils a GeoData with the parsed location" do
        expect(::GeoData).to receive(:new).with(location: "GeometryCollection (Point (-10.0 -10.0))")
        presenter.send :_parse_location, vals, :after
      end
    end
  end
end

