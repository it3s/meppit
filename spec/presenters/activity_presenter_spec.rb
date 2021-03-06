require 'spec_helper'

describe ActivityPresenter do
  let(:geo_data) { FactoryGirl.create :geo_data }
  let(:map) { FactoryGirl.create :map }
  let(:user) { FactoryGirl.create :user }
  let(:obj) { geo_data }

  let(:ctx) { ApplicationController.new.view_context }
  let(:activity) { obj.create_activity :update, owner: user, parameters: {changes: {"name"=>["bla", obj.try(:name)]}} }
  let(:presenter) { ActivityPresenter.new object: activity, ctx: ctx }

  describe "#trackable" do
    it { expect(presenter.trackable).to eq geo_data }
  end

  describe "#owner" do
    it { expect(presenter.owner).to eq user }
  end

  describe "#name" do
    it { expect(presenter.name).to eq geo_data.name }
  end

  describe "#type" do
    context "geo_data" do
      it { expect(presenter.type).to eq :geo_data }
    end
    context "map" do
      let(:obj) { map }
      it { expect(presenter.type).to eq :map }
    end
    context "user" do
      let(:obj) { user }
      it { expect(presenter.type).to eq :user }
    end
  end

  describe "#avatar" do
    context "geo_data" do
      it { expect(presenter.avatar).to eq ctx.icon(:'map-marker') }
    end
    context "map" do
      let(:obj) { map }
      it { expect(presenter.avatar).to eq ctx.icon(:globe) }
    end
    context "user itself" do
      let(:obj) { user }
      it { expect(presenter.avatar).to eq ctx.icon(:user) }
    end
    context "user but not itself" do
      let(:other_user) { FactoryGirl.create :user, name: 'Jane'}
      let(:obj) { other_user }
      before {
        allow(presenter.trackable).to receive(:avatar?).and_return true
        allow(presenter.trackable).to receive(:avatar).and_return(double thumb: double(url: 'some-image.png' ))
      }

      it { expect(presenter.avatar).to eq "<img alt=\"Some image\" src=\"/images/some-image.png\" />" }
    end
    context "unknown" do
      let(:obj) { map }
      before {allow(presenter).to receive(:type).and_return :unknown }
      it { expect(presenter.avatar).to eq ctx.icon(:question) }
    end
  end

  describe "#owner_avatar" do
    context "user itself" do
      let(:obj) { user }
      it { expect(presenter.owner_avatar).to eq "<img alt=\"Avatar placeholder\" src=\"/assets/imgs/avatar-placeholder.png\" />" }
    end
    context "user but not itself" do
      let(:other_user) { FactoryGirl.create :user, name: 'Jane'}
      let(:obj) { other_user }
      before { allow(presenter.owner).to receive(:thumb).and_return(double url: '' ) }

      it { expect(presenter.owner_avatar).to eq "<img alt=\"Avatar placeholder\" src=\"/assets/imgs/avatar-placeholder.png\" />" }
    end
  end

  describe "#changes" do
    it { expect(presenter.changes).to eq "<i class=\"fa fa-edit\"></i> name"}

    context "empty" do
      it "return empty string" do
        presenter.object.parameters = {}
        expect(presenter.changes).to eq ""
      end
    end
  end

  describe "#time" do
    it { expect(presenter.time.to_s).to eq presenter.object.created_at.to_s }
  end

  describe "#url" do
    it { expect(ctx).to receive(:url_for).with(obj); presenter.url }
  end

  describe "#time_ago" do
    it { expect(ctx).to receive(:t).with('time_ago', time: anything); presenter.time_ago }
  end

  describe "#event_type" do
    it { expect(ctx).to receive(:t).with("activities.event.update"); presenter.event_type }
  end

  describe "#event" do
    before {
      allow(presenter).to receive(:event_type).and_return 'EVENTTYPE'
      allow(presenter).to receive(:headline).and_return 'HEADLINE'
    }
    it { expect(presenter.event).to include('EVENTTYPE', 'HEADLINE') }
  end

  describe "#event_with_owner" do
    before {
      allow(presenter).to receive(:event_type).and_return 'EVENTTYPE'
      allow(presenter).to receive(:headline).and_return 'HEADLINE'
      allow(presenter).to receive(:owner_link).and_return 'OWNERLINK'
    }
    it { expect(presenter.event_with_owner).to include('EVENTTYPE', 'HEADLINE', 'OWNERLINK') }
  end

  describe "#owner_link" do
    before { allow(ctx).to receive(:url_for).and_return 'URL' }
    it { expect(presenter.owner_link).to include('URL', 'event-owner', user.name) }
  end

  describe "#user_itself" do
    context "itself" do
      let(:obj) { user }
      it { expect(presenter.user_itself?).to be true }
    end
    context "other" do
      let(:other_user) { FactoryGirl.create :user, name: 'Jane'}
      let(:obj) { other_user }
      it { expect(presenter.user_itself?).to be false }
    end
  end

  describe "#headline" do
    context "any other object" do
      before { allow(presenter).to receive(:url).and_return("/") }
      it { expect(presenter.headline).to match obj.name }
    end

    context "user_itself" do
      let(:obj) { user }
      before { allow(presenter).to receive(:url).and_return("/") }
      it { expect(presenter.headline).to match ctx.t("profile") }
    end
  end
end
