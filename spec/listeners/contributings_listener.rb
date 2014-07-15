require 'spec_helper'

describe ContributingsListener do
  let(:listener) { ContributingsListener.new }
  let(:geo_data) { FactoryGirl.create :geo_data }
  let(:map) { FactoryGirl.create :map }
  let(:user) { FactoryGirl.create :user }

  before { EventBus.subscribe(listener) }

  describe "geo_data_updated" do
    it "calls save_contribution when geo_data_updated event is raised" do
      expect(listener).to receive(:save_contribution).with(geo_data, user)
      EventBus.publish 'geo_data_updated', geo_data: geo_data, current_user: user
    end
  end

  describe "map_updated" do
    it "calls save_contribution when map_updated event is raised" do
      expect(listener).to receive(:save_contribution).with(map, user)
      EventBus.publish 'map_updated', map: map, current_user: user
    end
  end

  describe "#save_contribution" do
    it "logs error if any arg is nil" do
      expect(Rails.logger).to receive(:error)
      listener.send(:save_contribution, nil, nil)
    end
    it "calls add_contributor on the contributable" do
      expect(geo_data).to receive(:add_contributor).with(user)
      listener.send(:save_contribution, geo_data, user)
    end
  end
end
