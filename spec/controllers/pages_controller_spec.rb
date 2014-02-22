require 'spec_helper'

describe PagesController do

  describe "GET frontpage" do
    before { get :frontpage }

    it { expect(response).to render_template :frontpage }

    it { expect(assigns :news).to_not be_nil }
  end

end
