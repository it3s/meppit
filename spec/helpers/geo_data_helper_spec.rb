require 'spec_helper'

describe GeoDataHelper do
  let(:user) { FactoryGirl.build(:user, name: 'John') }
  let(:data) { FactoryGirl.build(:geo_data) }

  context "user logged" do
    before {  helper.stub(:current_user).and_return(user) }
    it { expect(helper.data_tools).to eq [:edit, :star, :history, :flag, :delete] }
  end

  context "user not logged" do
    before {  helper.stub(:current_user).and_return(nil) }
    it { expect(helper.data_tools).to eq [:star, :history, :flag, :delete] }
  end
end
