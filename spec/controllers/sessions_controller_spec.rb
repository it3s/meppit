require 'spec_helper'

describe SessionsController do

  describe "POST create" do
    before { post :create, params }

    let(:passwd) { '123456' }

    context "invalid data" do
      shared_examples_for "return json with :unprocessable_entity" do
        it { expect(response.status).to eq 422 }
        it { expect(response.header['Content-Type']).to match 'application/json' }
      end

      describe "no data" do
        let(:params) { {} }
        it { expect(response.body).to match({:errors => 'Fields can\'t be blank' }.to_json) }
        it_behaves_like "return json with :unprocessable_entity"
      end

      describe "user pending" do
        let!(:user) { FactoryGirl.create(:pending_user, :password => passwd) }
        let(:params) { {:email => user.email, :password => passwd} }

        it { expect(response.body).to match({:errors => 'Activation pending'}.to_json) }
        it_behaves_like "return json with :unprocessable_entity"
      end

      describe "imvalid email or password" do
        let!(:user) { FactoryGirl.create(:user, :password => passwd) }
        let(:params) { {:email => user.email, :password => '321654'} }

        it { expect(response.body).to match({:errors => 'E-mail or Password invalid'}.to_json) }
        it_behaves_like "return json with :unprocessable_entity"
      end
    end

    context "valid data" do
      let!(:user) { FactoryGirl.create(:user, :password => passwd) }
      let(:params) { {:email => user.email, :password => passwd} }

      it { expect(response.body).to match({:redirect => root_path}.to_json) }
      it { expect(response).to be_success }
      it { expect(response.header['Content-Type']).to match 'application/json' }
    end
  end

  describe "GET destroy" do
    it "log out the user" do
      controller.should_receive(:logout)
      get :destroy
    end

    it "redirects to root" do
      get :destroy
      expect(response).to redirect_to(root_path)
    end
  end

end
