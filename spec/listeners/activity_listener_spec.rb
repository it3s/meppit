require 'spec_helper'

describe ActivityListener do
  let(:listener) { ActivityListener.new }
  let(:geo_data) { FactoryGirl.create :geo_data }
  let(:map) { FactoryGirl.create :map }
  let(:user) { FactoryGirl.create :user }

  before { EventBus.subscribe(listener) }

    it "calls save_activity when geo_data_updated event is raised" do
      expect(listener).to receive(:save_activity).with(anything, :geo_data, :update)
      EventBus.publish 'geo_data_updated', geo_data: geo_data, current_user: user, changes: {}
    end

    it "calls save_activity when geo_data_created event is raised" do
      expect(listener).to receive(:save_activity).with(anything, :geo_data, :create)
      EventBus.publish 'geo_data_created', geo_data: geo_data, current_user: user, changes: {}
    end

    it "calls save_activity when map_updated event is raised" do
      expect(listener).to receive(:save_activity).with(anything, :map, :update)
      EventBus.publish 'map_updated', map: map, current_user: user, changes: {}
    end

    it "calls save_activity when map_created event is raised" do
      expect(listener).to receive(:save_activity).with(anything, :map, :create)
      EventBus.publish 'map_created', map: map, current_user: user, changes: {}
    end

    it "calls save_activity when followed event is raised" do
      expect(listener).to receive(:save_activity).with(anything, :object, :follow)
      EventBus.publish 'followed', object: geo_data, current_user: user, changes: {}
    end

    describe "save_activity" do
      it "saves activity" do
        expect(geo_data.activities.count).to eq 0

        listener.send :save_activity, {geo_data: geo_data, current_user: user}, :geo_data, :update

        expect(geo_data.activities.count).to eq 1

        activity = geo_data.activities.first
        expect(activity.key).to eq 'geo_data.update'
        expect(activity.trackable).to eq geo_data
        expect(activity.owner).to eq user
      end

      it "build_notifications" do
        expect(Notification).to receive(:build_notifications)
        listener.send :save_activity, {geo_data: geo_data, current_user: user}, :geo_data, :update
      end
    end

    describe "cleaned_changes" do
      it "returns empty hash for no changes" do
        changes = listener.send :cleaned_changes, {}
        expect(changes).to eq({})
      end
      it "ignore specified keys" do
        changes = listener.send :cleaned_changes, changes: {"foo"=> "bar", "updated_at"=> 123, "administrator_id"=> 1}
        expect(changes).to eq({"foo"=> "bar"})
      end
      it "remove specified vals" do
        changes = listener.send :cleaned_changes, changes: {"avatar"=> [double("complex_obj"), double("complex_obj")]}
        expect(changes).to eq({"avatar"=> ["", ""]})
      end
    end
end
