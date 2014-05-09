require 'spec_helper'

describe UsersHelper do
  let(:user) { FactoryGirl.build(:user, name: 'John') }

  context "user on his own page" do
    before {  helper.stub(:current_user).and_return(user) }
    it { expect(helper.user_tools user).to eq [:edit, :settings, :star, :flag] }
  end

  context "user on anothers page" do
    let(:another_user) { FactoryGirl.build(:user, name: 'Jane')}
    before {  helper.stub(:current_user).and_return(user) }
    it { expect(helper.user_tools another_user).to eq [:star, :flag] }
  end
end
