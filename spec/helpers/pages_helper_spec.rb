require 'spec_helper'

describe PagesHelper do

  describe "#use_cases" do
    let(:keys) { [:href, :title, :image, :text] }
    it { expect(helper.use_cases).to be_a_kind_of Array }
    it { expect(helper.use_cases[0].keys).to eq keys }
  end

  describe "#projects_slides" do
    let(:keys) { [:name, :href, :image, :text, :author_href, :author_name, :author_title] }
    it { expect(helper.projects_slides).to be_a_kind_of Array }
    it { expect(helper.projects_slides[0].keys).to eq keys }
  end

end
