require 'spec_helper'

class FoosController < ApplicationController; end

describe ContributableController do
  controller (FoosController) do
    include ContributableController

    def update
      save_contribution @anonymous, current_user
      render :text => "update"
    end

    def set_object obj
      # Using "@anonymous" because "ContributableController" expects a
      # variable with the controller name
      @anonymous = obj
    end
  end

  describe "POST update" do
    let!(:user) { FactoryGirl.create :user }
    let!(:obj) { double }

    before { login_user user }

    it 'adds contributor to object' do
      expect(obj).to receive('add_contributor').with(user)
      controller.set_object obj
      post :update, {:id => user.id}
    end
  end
end
