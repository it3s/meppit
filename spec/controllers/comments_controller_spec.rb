require 'spec_helper'

describe CommentsController do
  let(:geo_data) { FactoryGirl.create :geo_data }
  let(:user) { FactoryGirl.create :user }

  describe "POST create" do
    let(:params) { {:geo_data_id => geo_data.id, :comment => { :comment => "new comment"} } }

    before { login_user user }

    it 'saves comment and return json with rendered comment' do
      post :create, params
      expect(assigns :commentable).to eq geo_data
      expect(JSON.parse(response.body).keys.include?('comment_html')).to be true
    end

    it "publishes commented event to EventBus" do
      expect(EventBus).to receive(:publish).with("commented", anything)
      post :create, params
    end

    it 'validates model and returns errors' do
      post :create, params.merge(comment: {comment: nil})
      expect(response.body).to eq({:errors => {:comment => [controller.t('activerecord.errors.messages.blank')]}}.to_json)
    end
  end
end
