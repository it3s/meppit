require 'spec_helper'
require 'carrierwave/test/matchers'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  let(:user) { FactoryGirl.create(:user) }

  before do
    AvatarUploader.enable_processing = true
    user.process_avatar_upload = true
    @uploader = AvatarUploader.new(user, :avatar)
    @uploader.thumb.enable_processing = true
    path = Rails.root.join('app', 'assets', 'images', 'imgs', 'avatar-placeholder.png')
    @uploader.store!(File.open path)
  end

  after do
    AvatarUploader.enable_processing = false
    @uploader.remove!
  end

  it { expect(subject.extension_white_list).to eq ['jpg', 'jpeg', 'png'] }
  it { expect(subject.default_url).to eq '/assets/imgs/avatar-placeholder.png' }

  context 'the thumb version' do
    it "should scale down a landscape image to be exactly 240 by 200 pixels" do
      expect(@uploader.thumb).to be_no_larger_than(240, 200)
    end
  end
end
