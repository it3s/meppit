require 'spec_helper'


describe ToolbarPresenter do
  let(:user) { FactoryGirl.build :user }
  let(:geo_data) { FactoryGirl.build :geo_data }
  let(:map) { FactoryGirl.build :map }

  let(:logged_in)  { mock_context(:in) }
  let(:logged_out) { mock_context(:out) }
  let(:logged_in_admin) { mock_context(:in, true) }

  def mock_context(type=:in, admin=false)
    _user = (type == :in) ? user : nil
    params = { id: _user.try(:id) }
    double('Context', current_user: _user, is_admin?: admin, params: params, t: '', url_for: '', request: double('request', path: ''), follow_options_for: '{}', settings_path: '')
  end

  def tp(obj, ctx=nil)
    ctx ||= logged_in
    ToolbarPresenter.new object: obj, ctx: ctx
  end

  describe "#type" do
    it { expect( tp(user).type ).to eq 'user' }
    it { expect( tp(geo_data).type ).to eq 'geo_data' }
  end

  describe "#available_tools" do
    let (:presenter) { tp user }
    it { expect(presenter.available_tools).to be_a_kind_of Array }
    it { expect(presenter.available_tools.size).to eq 7 }
    it { expect(presenter.available_tools.first).to be_a_kind_of Symbol }
  end

  describe "#select_tools" do
    context "user" do
      context "same user logged" do
        let (:presenter) { tp user, logged_in }
        it { expect(presenter.select_tools).to eq [:edit, :settings] }
      end

      context "different user logged" do
        let (:presenter) { tp user, logged_out }
        it { expect(presenter.select_tools).to eq [:star, :flag] }
      end
    end

    context "geo_data" do
      context "logged in" do
        let(:presenter) { tp geo_data, logged_in }
        it { expect(presenter.select_tools).to eq [:edit, :star, :history, :flag, :delete] }
      end

      context "logged out" do
        let(:presenter) { tp geo_data, logged_out }
        it { expect(presenter.select_tools).to eq [:star, :history, :flag, :delete] }
      end
    end

    context "map" do
      context "logged in" do
        let(:presenter) { tp map, logged_in }
        it { expect(presenter.select_tools).to eq [:edit, :star, :history, :flag, :delete] }
      end

      context "logged out" do
        let(:presenter) { tp map, logged_out }
        it { expect(presenter.select_tools).to eq [:star, :history, :flag, :delete] }
      end
    end

    context "any other" do
      let(:presenter) { tp double('object'), logged_in }
      it { expect(presenter.select_tools).to eq presenter.available_tools }
    end
  end

  describe "#tools" do
    let (:presenter) { tp user, logged_in }

    it "returns a list of OpenStructs" do
      expect(presenter.tools).to be_a_kind_of Array
      expect(presenter.tools.first).to be_a_kind_of OpenStruct
    end
  end

  describe "tools options" do
    let(:presenter) { tp double('object'), logged_in }

    it "has icon, title and url options for all tools" do
      presenter.tools.each { |tool|
        expect(tool.icon ).to be_a_kind_of Symbol
        expect(tool.title).to be_a_kind_of String
        expect(tool.url  ).to be_a_kind_of String
      }
    end
  end

end
