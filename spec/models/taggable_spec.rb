require 'spec_helper'

describe Taggable do
  # TODO: user a dummy model to test taggable in isolation

  let(:user) { FactoryGirl.build :user }

  before { Tag.delete_all }

  it { expect(User.method(:searchable_tags)).to_not raise_error }

  it "sends callback and save tags" do
    expect(Tag.all.map(&:tag)).to eq []
    user.interests = ['aa', 'bb']
    user.save
    expect(Tag.all.map(&:tag)).to match_array ['aa', 'bb']
  end
end
