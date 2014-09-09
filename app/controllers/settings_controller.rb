class SettingsController < ApplicationController
  before_action :require_login
  before_action :find_user

  def show
  end

  def update
    render json: {}
  end

  private

    def find_user
      @user = User.find(params[:id])
      redirect_to root_path, notice: t('access_denied') unless @user == current_user
    end
end
