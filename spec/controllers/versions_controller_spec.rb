require 'spec_helper'

describe VersionsController, versioning: true do

  describe "GET history" do

    shared_examples_for "history versioning" do
      it "finds the versionable" do
        get :history, params
        expect(assigns[:versionable]).to eq target
      end

      it "expects to render versions/history" do
        get :history, params
        expect(response).to render_template('versions/history')
      end

      it "expects to render layout nil if xhr" do
        allow(controller.request).to receive(:xhr?).and_return true
        get :history, params
        expect(response).to render_template(layout: nil)
      end
    end

    context "geo_data" do
      let(:target) { FactoryGirl.create :geo_data }
      let(:params) { {geo_data_id: target.id} }

      it_behaves_like "history versioning"
    end

    context "maps" do
      let(:target) { FactoryGirl.create :map }
      let(:params) { {map_id: target.id} }

      it_behaves_like "history versioning"
    end
  end

  describe "POST revert" do
    let(:user) { FactoryGirl.create :user }

    shared_examples_for "reversible" do
      let!(:version) {target.versions.last}

      it "requires login" do
        logout_user
        post :revert, id: version.id
        expect(response).to redirect_to login_path
      end

      context "logged in" do
        before { login_user user }


        it "find version" do
          post :revert, id: version.id
          expect(assigns[:version]).to eq version
        end

        it "call revert_to_version!" do
          expect(controller).to receive(:revert_to_version!).and_return target
          post :revert, id: version.id
        end

        it "reverts to this version" do
          expect(target.name).to eq "new name"
          post :revert, id: version.id
          expect(response).to redirect_to target
          expect(target.reload.name).to eq "old name"
        end
      end
    end

    context "geo_data" do
      let!(:target) do
        geo_data = FactoryGirl.create :geo_data, name: "old name"
        geo_data.update_attributes! name: "new name"
        geo_data
      end

      it_behaves_like "reversible"
    end

    context "map" do
      let!(:target) do
        map = FactoryGirl.create :map, name: "old name"
        map.update_attributes! name: "new name"
        map
      end

      it_behaves_like "reversible"
    end
  end

  describe "GET show" do
    pending
  end

  describe "build_object_for_version" do
    pending
  end

  describe "revert_to_version!" do
    pending
  end

  describe "reified_object" do
    pending
  end

  describe "version_location" do
    pending
  end
end
