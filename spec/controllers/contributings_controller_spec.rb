require 'spec_helper'

describe ContributingsController do
  describe "GET contributors from geo_data" do
    let(:geo_data) { FactoryGirl.create :geo_data }
    context "regular request" do
      it 'defines @geo_data' do
        get :contributors, :geo_data_id => geo_data.id
        expect(assigns :geo_data).to eq geo_data
      end
      it 'renders contributors list with layout' do
        get :contributors, :geo_data_id => geo_data.id
        expect(response).to render_template :application
      end
    end
    context "xhr" do
      before { controller.request.stub(:xhr?).and_return(true) }

      it 'renders contributors list without layout' do
        get :contributors, :geo_data_id => geo_data.id
        expect(response).to render_template(:layout => nil)
      end
    end
  end

  describe "GET contributions" do
    let(:user) { FactoryGirl.create :user }
    context "regular request" do
      it 'defines @user' do
        get :contributions, :user_id => user.id
        expect(assigns :user).to eq user
      end
      it 'renders contributions list with layout' do
        get :contributions, :user_id => user.id
        expect(response).to render_template :application
      end
    end
    context "xhr" do
      before { controller.request.stub(:xhr?).and_return(true) }

      it 'renders contributions list without layout' do
        get :contributions, :user_id => user.id
        expect(response).to render_template(:layout => nil)
      end
    end
  end
end
