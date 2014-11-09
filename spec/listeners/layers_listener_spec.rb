require 'spec_helper'

describe LayersListener do
  let(:listener) { ContributingsListener.new }
  let(:map) { FactoryGirl.create :map }

  before {
    EventBus.subscribe(listener)
    map.layers_attributes = attrs
  }

  context "do not have layers_attributes" do
    let(:attrs) { nil }
    it "expect to not call save_layers_from_attributes" do
      expect(map).to_not receive(:save_layers_from_attributes)
      EventBus.publish 'map_updated', map: map
    end
  end
  context "has layers_attributes" do
    let(:attrs) { {} }
    it "expect to call save_layers_from_attributes" do
      expect(map).to receive(:save_layers_from_attributes)
      EventBus.publish 'map_updated', map: map
    end
  end
end
