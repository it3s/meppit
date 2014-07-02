require 'spec_helper'

class DummyPresenter < Presenter
end

class RequiredKeysPresenter < Presenter
  required_keys :object, :ctx

  def say
    "object is #{object}"
  end
end

describe Presenter do
  context "non required keys" do
    let(:presenter) { DummyPresenter.new a: 10, b: 'str' }

    it "initilaizer the presenter with instance variables taken from a hash" do
      expect(presenter.instance_variable_get :@a).to eq 10
      expect(presenter.instance_variable_get :@b).to eq 'str'
    end

    it 'creates getter methods' do
      expect(presenter.a).to eq 10
      expect(presenter.b).to eq 'str'
    end

    it 'creates setter methods' do
      expect(presenter.a).to eq 10
      presenter.a = 20
      expect(presenter.a).to eq 20
    end
  end

  context "required keys" do
    let(:presenter) { RequiredKeysPresenter.new object: '_obj_', ctx: {} }

    describe 'raises error if required key is missing' do
      it { expect { RequiredKeysPresenter.new a: 1 }.to raise_error "Required key: object" }
      it { expect { RequiredKeysPresenter.new object: '_obj_' }.to raise_error "Required key: ctx" }
      it { expect { RequiredKeysPresenter.new object: '_obj_', ctx: {}}.to_not raise_error }
    end

    it { expect(presenter.say).to eq 'object is _obj_' }
  end
end
