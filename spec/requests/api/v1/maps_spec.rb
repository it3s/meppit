require 'spec_helper'

describe "API::V1::Maps" do
  let(:map) { FactoryGirl.create :map }
  let(:user) { FactoryGirl.create :user }

  describe "GET show" do
    describe "deny non authenticated requests" do
      it "401 unauthorized when auth_token is empty" do
        get "/api/v1/maps/#{map.id}"
        expect(response.status).to eq 401
        expect(response.body).to match 'HTTP Token: Access denied.'
      end
      it "401 unauthorized when auth_token is invalid" do
        get "/api/v1/maps/#{map.id}", {}, {'Authorization'=>"Token token=fake_token"}
        expect(response.status).to eq 401
        expect(response.body).to match 'HTTP Token: Access denied.'
      end
    end

    context "authenticated" do
      before { get "/api/v1/maps/#{map.id}", {}, headers }

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

      context "geojson" do
        let(:headers) { {'Authorization'=>"Token token=#{user.auth_token}", "Accept"=>Mime::GEOJSON} }

        it { expect(response.status).to eq 200 }
        it { expect(response.content_type).to eq Mime::GEOJSON }
      end
    end
  end

  describe "GET index" do
    describe "deny non authenticated requests" do
      it "401 unauthorized when auth_token is empty" do
        get "/api/v1/maps"
        expect(response.status).to eq 401
        expect(response.body).to match 'HTTP Token: Access denied.'
      end
      it "401 unauthorized when auth_token is invalid" do
        get "/api/v1/maps", {}, {'Authorization'=>"Token token=fake_token"}
        expect(response.status).to eq 401
        expect(response.body).to match 'HTTP Token: Access denied.'
      end
    end

    context "authenticated" do
      before { get "/api/v1/maps", {}, headers }

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

      context "geojson" do
        let(:headers) { {'Authorization'=>"Token token=#{user.auth_token}", "Accept"=>Mime::GEOJSON} }

        it { expect(response.status).to eq 200 }
        it { expect(response.content_type).to eq Mime::GEOJSON }
      end
    end

    context "params" do
      let (:headers) { {'Authorization'=>"Token token=#{user.auth_token}", "Accept"=>Mime::JSON} }
      before do
        ['b', 'c', 'a', 'd'].each { |n| FactoryGirl.create :map, name: n, tags: ['z', n] }
      end
      describe "pagination" do
        it "gets the correct number of objects per page" do
          get "/api/v1/maps", {page: 1, per: 2}, headers
          expect(JSON::parse(response.body).count).to eq 2
        end
        it "gets the correct objects" do
          get "/api/v1/maps", {page: 2, per: 2}, headers
          expect(JSON::parse(response.body).map{ |item| item["name"] }).to match_array ["a", "d"]
        end
        it "gets the pagination headers" do
          get "/api/v1/maps", {page: 2, per: 2}, headers
          expect(response.headers.has_key? "Link").to be true
          expect(response.headers.has_key? "X-Per-Page").to be true
          expect(response.headers.has_key? "X-Pages").to be true
          expect(response.headers.has_key? "X-Total-Count").to be true

          expect(response.headers["X-Per-Page"]).to eq "2"
          expect(response.headers["X-Pages"]).to eq "2"
          expect(response.headers["X-Total-Count"]).to eq "4"
        end
      end
    end
  end
end
