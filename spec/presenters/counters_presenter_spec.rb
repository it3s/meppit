require 'spec_helper'

describe CountersPresenter do
  let(:object) { double('object', data_count: 1, followers_count: 2) }
  let(:presenter) { CountersPresenter.new object: object, ctx: double('ctx', url_for: 'url', identifier_for: 'id#num') }

  describe "#size_" do
    it "default size is medium" do
      expect(presenter.size_).to eq :medium
    end

    context "size is big" do
      let(:presenter) { CountersPresenter.new object: object, ctx: double('ctx'), size: :big }
      it "gets the defined value" do
        expect(presenter.size_).to eq :big
      end
    end
  end

  describe "#counter_url" do
    let(:presenter) { CountersPresenter.new object: object, ctx: double('ctx') }
    it "tries reversed params if fails" do
      expect(presenter.ctx).to receive(:url_for).with([1, 2]).and_raise Exception
      expect(presenter.ctx).to receive(:url_for).with([2, 1]).and_return "url"
      expect(presenter.send(:counter_url, [1, 2])).to eq "url"
    end
  end

  describe "#counters" do
    it "selects only the ones which object has the corresponding count method" do
      allow(presenter.ctx).to receive(:identifier_for)
      expect(presenter.counters.size).to eq 2
    end

    it "returns an array of OpenStructs" do
      allow(presenter.ctx).to receive(:identifier_for)
      expect(presenter.counters).to be_a_kind_of Array
      expect(presenter.counters.first).to be_a_kind_of OpenStruct
    end
  end

  describe "#counter_options" do
    it "calls corresponding counter options method" do
      _orig = presenter.send :_data_counter
      expect(presenter).to receive(:_data_counter).and_return(_orig)
      presenter.counter_options :data
    end

    it "get count if object has method" do
      expect(presenter.object.try :data_count).to eq 1
      expect(presenter.counter_options(:data)[:count]).to eq 1
    end

    it "count defaults to 0" do
      expect(presenter.object.try :maps_count).to be nil
      expect(presenter.counter_options(:maps)[:count]).to eq 0
    end

    describe "value" do
      context "size is :big" do
        let(:presenter) { CountersPresenter.new object: object, ctx: double('ctx', url_for: 'url', identifier_for: 'id#num'), size: :big}

        it "calls i18n method" do
          expect(presenter.ctx).to receive(:t).with('counters.data', count: "<em class=\"counter-label\">1</em>")
          opts = presenter.counter_options :data
        end
      end
      context "another size" do
        let(:opts) { presenter.counter_options :data }

        it { expect(opts[:value]).to eq "<span class=\"counter-label\">#{opts[:count]}</span>" }
      end
    end
  end

end
