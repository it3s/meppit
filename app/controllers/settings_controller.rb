class SettingsController < ApplicationController
  before_action :require_login
  before_action :set_user

  def show
  end

  def update
    @settings.assign_attributes(params[:settings])
    flash[:notice] = @settings.save ? t('flash.saved') : t('settings.error')
    render json: {redirect: user_path(@user)}
  end

  private

    def set_user
      redirect_to root_path, notice: t('access_denied') unless current_user.id == params[:id].to_i
      @user = current_user
      @settings = @user.settings
    end
end
