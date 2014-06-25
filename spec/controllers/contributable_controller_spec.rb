require 'spec_helper'

class FoosController < ApplicationController; end

describe ContributableController do
  controller (FoosController) do
    include ContributableController

    def update
      save_contribution @anonymous, current_user
      render :text => "update"
    end

    def set_object(obj)
      # Using "@anonymous" because "ContributableController" expects a
      # variable with the controller name
      @anonymous = obj
    end
  end

  describe "POST update" do
    let!(:user) { FactoryGirl.create :user }
    let!(:obj) { double }

    describe "logged in" do
      before { login_user user }

      it 'adds contributor to object' do
        expect(obj).to receive('add_contributor').with(user)
        controller.set_object obj
        post :update, {:id => 1}
      end

      it 'fails if object was not defined, but dont raise an exception' do
        expect(obj).to_not receive('add_contributor').with(user)
        controller.set_object nil
        post :update, {:id => 1}
      end
    end

    describe "not logged in" do
      it 'fails to add contributor to object' do
        expect(obj).to_not receive('add_contributor').with(user)
        controller.set_object obj
        post :update, {:id => 1}
      end
    end
  end
end
