require 'spec_helper'


describe ObjectPresenter do
  let(:user) { FactoryGirl.build :user }
  let(:geo_data) { FactoryGirl.build :geo_data }

  describe "#object_ref" do
    it { expect(ObjectPresenter.new(object: user).object_ref).to eq :user }
    it { expect(ObjectPresenter.new(object: geo_data).object_ref).to eq :geo_data }
  end

  describe "#controller_ref" do
    it { expect(ObjectPresenter.new(object: user).controller_ref).to eq 'users' }
    it { expect(ObjectPresenter.new(object: geo_data).controller_ref).to eq 'geo_data' }
  end

end
