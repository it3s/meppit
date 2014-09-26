require 'spec_helper'
require 'carrierwave/test/matchers'

describe PictureUploader do
  include CarrierWave::Test::Matchers

  let(:picture) { FactoryGirl.create(:picture) }

  before do
    PictureUploader.enable_processing = true
    picture.process_image_upload = true
    @uploader = PictureUploader.new(picture, :image)
    @uploader.thumb.enable_processing = true
    path = Rails.root.join('app', 'assets', 'images', 'imgs', 'avatar-placeholder.png')
    @uploader.store!(File.open path)
  end

  after do
    PictureUploader.enable_processing = false
    @uploader.remove!
  end

  it { expect(subject.extension_white_list).to eq ['jpg', 'jpeg', 'png'] }

  context 'the thumb version' do
    it "should scale down a landscape image to be exactly 240 by 200 pixels" do
      expect(@uploader.thumb).to be_no_larger_than(240, 200)
    end
  end
end
