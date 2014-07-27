require 'spec_helper'

describe VersionPresenter do
  let(:user) { FactoryGirl.create :user, name: 'John'}
  let(:time) { DateTime.new }
  let(:version) { double(whodunnit: user.id.to_s, event: "update",
    changeset: {name: ["joh", "John"], about_me: ["", "hi"]},
    created_at: time ) }
  let(:presenter) { VersionPresenter.new object: version, ctx: double('ctx', t: '') }

  describe "#author" do
    it { expect(presenter.author).to eq user }
  end

  describe "#author_name" do
    it { expect(presenter.author_name).to eq "John" }
  end

  describe "#event" do
    it "expects to get translated event type" do
      expect(presenter.ctx).to receive(:t).with("versions.event.update")
      presenter.event
    end
  end

  describe "#changes" do
    it { expect(presenter.changes).to eq "name and about_me" }
  end

  describe "#time" do
    it { expect(presenter.time).to eq time }
  end

  describe "#time_ago" do
    it "calls time_ago_in_words helper" do
      expect(presenter.ctx).to receive(:time_ago_in_words).and_return ""
      presenter.time_ago
    end
  end

  describe "#diff_items" do
    it "creates a Hash with OpenStructs containing before and after values" do
      diff_items = presenter.diff_items

      expect(diff_items.keys).to eq [:name, :about_me]

      expect(diff_items[:name]).to be_a_kind_of OpenStruct
      expect(diff_items[:name].before).to eq "joh"
      expect(diff_items[:name].after).to eq "John"

      expect(diff_items[:about_me]).to be_a_kind_of OpenStruct
      expect(diff_items[:about_me].before).to eq ""
      expect(diff_items[:about_me].after).to eq "hi"
    end
  end
end
