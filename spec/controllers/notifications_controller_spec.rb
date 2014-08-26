require 'spec_helper'

describe NotificationsController do
  let(:user) { FactoryGirl.create :user }
  let(:other_user) { FactoryGirl.create :user, name: 'other' }
  let(:geo_data) { FactoryGirl.create :geo_data }
  let(:activity) { geo_data.create_activity :update, owner: other_user, parameters: {changes: {"name"=>["", geo_data.name]}} }
  let!(:notification) { Notification.create user: user, activity: activity }

  before { login_user user }

  describe "GET notifications" do
    before { get :notifications }

    it { expect(assigns :notifications).to_not eq [] }
    it { expect(assigns(:notifications).first.activity).to eq activity }
    it { expect(response).to render_template :notifications }
  end

  describe "GET read" do
    it 'sets notifications as read' do
      expect(notification.status).to eq 'unread'
      post :read, {notifications_ids: [notification.id]}
      expect(notification.reload.status).to eq 'read'
      expect(response.status).to eq 200
    end
  end
end
