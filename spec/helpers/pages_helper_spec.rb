require 'spec_helper'

describe PagesHelper do

  describe "#use_cases" do
    let(:keys) { [:href, :title, :sprite, :text] }

    it { expect(helper.use_cases).to be_a_kind_of Array }

    it { expect(helper.use_cases[0].keys).to eq keys }
  end

  describe "#testimonials" do
    let(:keys) { [:name, :href, :image, :text, :author_href, :author_name, :author_title] }

    it { expect(helper.testimonials).to be_a_kind_of Array }

    it { expect(helper.testimonials[0].keys).to eq keys }
  end

end
