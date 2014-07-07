require 'spec_helper'

describe CountersPresenter do
  let(:object) { double(data_count: 1, followers_count: 2) }
  let(:presenter) { CountersPresenter.new object: object, ctx: double}

  describe "#counters" do
    it "selects only the ones which object has the corresponding count method" do
      expect(presenter.counters.size).to eq 2
    end

    it "returns an array of OpenStructs" do
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
        let(:presenter) { CountersPresenter.new object: object, ctx: double, size: :big}

        it "calls i18n method" do
          expect(presenter.ctx).to receive(:t).with('counters.data', count: "<em>1</em>")
          opts = presenter.counter_options :data
        end
      end
      context "another size" do
        let(:opts) { presenter.counter_options :data }

        it { expect(opts[:value]).to eq opts[:count] }
      end
    end
  end

  describe "#size" do
    context "default" do
      let(:presenter) { CountersPresenter.new object: object, ctx: double}
      it { expect(presenter.size).to eq :medium }
    end

    context "with param" do
      let(:presenter) { CountersPresenter.new object: object, ctx: double, size: :big}
      it { expect(presenter.size).to eq :big }
    end
  end

end
