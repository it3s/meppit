require 'spec_helper'

describe "API::V1::GeoData" do
  let(:geo_data) { FactoryGirl.create :geo_data }
  let(:user) { FactoryGirl.create :user }

  describe "GET show" do
    describe "deny non authenticated requests" do
      it "401 unauthorized when auth_token is empty" do
        get "/api/v1/geo_data/#{geo_data.id}"
        expect(response.status).to eq 401
        expect(response.body).to match 'HTTP Token: Access denied.'
      end
      it "401 unauthorized when auth_token is invalid" do
        get "/api/v1/geo_data/#{geo_data.id}", {}, {'Authorization'=>"Token token=fake_token"}
        expect(response.status).to eq 401
        expect(response.body).to match 'HTTP Token: Access denied.'
      end
    end

    context "authenticated" do
      before { get "/api/v1/geo_data/#{geo_data.id}", {}, headers }

      context "json" do
        let(:headers) { {'Authorization'=>"Token token=#{user.auth_token}", "Accept"=>Mime::JSON} }

        it { expect(response.status).to eq 200 }
        it { expect(response.content_type).to eq Mime::JSON }
      end

      context "xml" do
        let(:headers) { {'Authorization'=>"Token token=#{user.auth_token}", "Accept"=>Mime::XML} }

        it { expect(response.status).to eq 200 }
        it { expect(response.content_type).to eq Mime::XML }
      end
    end
  end

  describe "GET index" do
    describe "deny non authenticated requests" do
      it "401 unauthorized when auth_token is empty" do
        get "/api/v1/geo_data"
        expect(response.status).to eq 401
        expect(response.body).to match 'HTTP Token: Access denied.'
      end
      it "401 unauthorized when auth_token is invalid" do
        get "/api/v1/geo_data", {}, {'Authorization'=>"Token token=fake_token"}
        expect(response.status).to eq 401
        expect(response.body).to match 'HTTP Token: Access denied.'
      end
    end

    context "authenticated" do
      before { get "/api/v1/geo_data", {}, headers }

      context "json" do
        let(:headers) { {'Authorization'=>"Token token=#{user.auth_token}", "Accept"=>Mime::JSON} }

        it { expect(response.status).to eq 200 }
        it { expect(response.content_type).to eq Mime::JSON }
      end

      context "xml" do
        let(:headers) { {'Authorization'=>"Token token=#{user.auth_token}", "Accept"=>Mime::XML} }

        it { expect(response.status).to eq 200 }
        it { expect(response.content_type).to eq Mime::XML }
      end
    end
  end
end
