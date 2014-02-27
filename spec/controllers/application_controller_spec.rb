require 'spec_helper'

describe ApplicationController do
  describe '#set_locale' do
    it 'sets from user.language' do
      controller.stub_chain(:current_user, :language).and_return :de
      expect(controller.set_locale).to eq :de
    end

    it 'gets from http header' do
      controller.stub_chain(:current_user, :language).and_return nil
      controller.stub(:extract_from_header).and_return :'pt-BR'
      expect(controller.set_locale).to eq :'pt-BR'
    end

    it 'defaults to I18n.default_locale' do
      controller.stub_chain(:current_user, :language).and_return nil
      controller.stub(:extract_from_header).and_return nil
      expect(controller.set_locale).to_not be_nil
      expect(controller.set_locale).to eq I18n.default_locale
    end
  end
end
