require 'spec_helper'
require 'carrierwave/test/matchers'

describe ImportUploader do
  include CarrierWave::Test::Matchers

  it { expect(subject.extension_white_list).to eq ['csv'] }
end
