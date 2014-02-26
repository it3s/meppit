require "spec_helper"

describe "Pages" do
  describe "frontpage" do
    before { visit root_path }

    it 'define frontpage' do
      expect(page.status_code).to equal 200
    end
  end
end
