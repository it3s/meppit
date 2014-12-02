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

      it "gets versions is reverse creation date order" do
        get :history, params
        expect(assigns[:versions].explain). to match "ORDER BY created_at desc"
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
    let(:user) { FactoryGirl.create :user }

    shared_examples_for "show version" do
      let!(:version) {target.versions.last}

      before { login_user user }

      it "find version" do
        post :revert, id: version.id
        expect(assigns[:version]).to eq version
      end

      it "builds object for this version" do
        post :show, id: version.id
        expect(assigns[:object].name).to eq "old name"
      end

      it "render versions/show with layout nil" do
        post :show, id: version.id
        expect(response).to render_template "versions/show"
        expect(response).to render_template layout: nil
      end
    end

    context "geo_data" do
      let!(:target) do
        geo_data = FactoryGirl.create :geo_data, name: "old name"
        geo_data.update_attributes! name: "new name"
        geo_data
      end

      it_behaves_like "show version"
    end

    context "map" do
      let!(:target) do
        map = FactoryGirl.create :map, name: "old name"
        map.update_attributes! name: "new name"
        map
      end

      it_behaves_like "show version"
    end
  end

  describe "revert_to_version!" do
    let!(:geo_data) do
      geo_data = FactoryGirl.create :geo_data, name: "old name"
      geo_data.update_attributes! name: "new name"
      geo_data
    end

    it "rebuilds the object for a given version and save" do
      expect(geo_data.name).to eq "new name"
      controller.instance_variable_set "@version", geo_data.versions.last
      controller.send :revert_to_version!
      expect(geo_data.reload.name).to eq "old name"
    end
  end

  describe "reified_object" do
    let!(:geo_data) do
      geo_data = FactoryGirl.create :geo_data, name: "old name"
      geo_data.update_attributes! name: "new name"
      geo_data
    end

    it "rebuilds the object for a given version" do
      expect(geo_data.name).to eq "new name"
      controller.instance_variable_set "@version", geo_data.versions.last
      expect(controller.send(:reified_object).name).to eq "old name"
    end
  end

  describe "version_location" do
    let!(:geo_data) do
      geo_data = FactoryGirl.create :geo_data, location: "Point (-10.0 -10.0)"
      geo_data.update_attributes! location: nil
      geo_data
    end

    it "parses properly the wkt string for the location of a reified object" do
      expect(geo_data.location).to eq nil
      controller.instance_variable_set "@version", geo_data.versions.last
      expect(controller.send(:version_location)).to eq "Point (-10.0 -10.0)"
    end
    it "returns nil if version has no location" do
      controller.instance_variable_set "@version", double(object: "no_location: true")
      expect(controller.send(:version_location)).to be nil
    end
  end
end
