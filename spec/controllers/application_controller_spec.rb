require 'spec_helper'

describe ApplicationController do
  describe '#set_locale' do
    after(:each) do
      I18n.locale = I18n.default_locale
    end

    it 'gets from user.language' do
      controller.stub_chain(:current_user, :language).and_return :de
      expect(controller.send :set_locale).to eq :de
    end

    it 'gets from session (for annonymous user)' do
      controller.stub(:session).and_return({:language => :ch})
      expect(controller.send :set_locale).to eq :ch
    end

    it 'gets from http header' do
      controller.stub(:extract_from_header).and_return :'pt-BR'
      expect(controller.send :set_locale).to eq :'pt-BR'
    end

    it 'defaults to I18n.default_locale' do
      controller.stub(:extract_from_header).and_return nil
      expect(controller.send :set_locale).to_not be_nil
      expect(controller.send :set_locale).to eq I18n.default_locale
    end
  end

  describe "#language" do
    before { controller.request.env['HTTP_REFERER'] = "http://test.host/" }

    context "invalid code" do
      before { get :language, :code => code }

      shared_examples_for 'do not set language and redirect back' do
        it { expect(controller.session[:language]).to be_nil }
        it { expect(response).to redirect_to :back }
      end

      context 'nil' do
        let(:code) { '' }
        it_behaves_like 'do not set language and redirect back'
      end

      context 'unavailable code' do
        let(:code) { 'ch' }
        it_behaves_like 'do not set language and redirect back'
      end
    end

    context 'valid code' do
      let(:code) { 'pt-BR' }
      after { controller.session[:language] = nil }

      context 'annonymous user' do
        before { get :language, :code => code }
        it { expect(controller.session[:language]).to eq code }
      end

      context 'logged user' do
        let(:user) { FactoryGirl.create(:user) }

        before do
          login_user user
          get :language, :code => code
        end

        it "saves the language to the user" do
          expect(controller.current_user).to be_a_kind_of User
          expect(user.reload.language).to eq code
          expect(controller.session[:language]).to eq code
        end
      end
    end
  end

end
