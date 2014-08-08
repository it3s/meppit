require 'spec_helper'

describe RelationshipsListener do
  let(:listener) { ContributingsListener.new }
  let(:geo_data) { FactoryGirl.create :geo_data }

  before {
    EventBus.subscribe(listener)
    geo_data.relations_attributes = attrs
  }

  context "do not have relations_attributes" do
    let(:attrs) { nil }
    it "expect to not call save_relations_from_attributes" do
      expect(geo_data).to_not receive(:save_relations_from_attributes)
      EventBus.publish 'geo_data_updated', geo_data: geo_data
    end
  end
  context "has relations_attributes" do
    let(:attrs) { {} }
    it "expect to call save_relations_from_attributes" do
      expect(geo_data).to receive(:save_relations_from_attributes)
      EventBus.publish 'geo_data_updated', geo_data: geo_data
    end
  end
end
