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

  describe "#layout_partial" do
    context "splitted" do
      let(:presenter) { ObjectPresenter.new(object: user) }
      it { expect(presenter.layout_partial).to eq "shared/object_content/splitted" }
    end
    context "regular" do
      let(:presenter) { ObjectPresenter.new(object: geo_data) }
      it { expect(presenter.layout_partial).to eq "shared/object_content/regular" }
    end
  end

  describe "#header_partial" do
    context "default" do
      let(:presenter) { ObjectPresenter.new(object: user) }
      it { expect(presenter.header_partial).to eq "users/header" }
    end
    context "with partial parameter" do
      let(:presenter) { ObjectPresenter.new(object: user, header: 'my_partial') }
      it { expect(presenter.header_partial).to eq "my_partial" }
    end
  end

  describe "#content_partial" do
    context "default" do
      let(:presenter) { ObjectPresenter.new(object: user) }
      it { expect(presenter.content_partial).to eq "users/content" }
    end
    context "with partial parameter" do
      let(:presenter) { ObjectPresenter.new(object: user, content: 'my_partial') }
      it { expect(presenter.content_partial).to eq "my_partial" }
    end
  end

  describe "#side_pane_partial" do
    context "default" do
      let(:presenter) { ObjectPresenter.new(object: user) }
      it { expect(presenter.side_pane_partial).to eq "users/side_pane" }
    end
    context "with partial parameter" do
      let(:presenter) { ObjectPresenter.new(object: user, side_pane: 'my_partial') }
      it { expect(presenter.side_pane_partial).to eq "my_partial" }
    end
  end

  describe "#object_params" do
    let(:presenter) { ObjectPresenter.new(object: user) }
    it { expect(presenter.object_params ).to eq({user: user}) }
    it { expect(presenter.object_params(f: 'form_builder') ).to eq({user: user, f: 'form_builder'}) }
  end

  describe "hide_location" do
    context "default" do
      let(:presenter) { ObjectPresenter.new(object: user) }
      it { expect(presenter.hide_location?).to be false }
    end
    context "show location" do
      let(:presenter) { ObjectPresenter.new(object: user, show_location: true) }
      it { expect(presenter.hide_location?).to be false }
    end
    context "hide location" do
      let(:presenter) { ObjectPresenter.new(object: user, show_location: false) }
      it { expect(presenter.hide_location?).to be true }
    end
  end

  describe "hide_toolbar" do
    context "default" do
      let(:presenter) { ObjectPresenter.new(object: user) }
      it { expect(presenter.hide_toolbar?).to be false }
    end
    context "show toolbar" do
      let(:presenter) { ObjectPresenter.new(object: user, show_toolbar: true) }
      it { expect(presenter.hide_toolbar?).to be false }
    end
    context "hide location" do
      let(:presenter) { ObjectPresenter.new(object: user, show_toolbar: false) }
      it { expect(presenter.hide_toolbar?).to be true }
    end
  end
end
