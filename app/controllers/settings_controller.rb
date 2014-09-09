class SettingsController < ApplicationController
  before_action :require_login
  before_action :set_user

  def show
  end

  def update
    @settings.assign_attributes(params[:settings])
    if @settings.valid? && @settings.save
      flash[:notice] = t('flash.saved')
      render json: {redirect: user_path(@user)}
    else
      render json: {errors: @settings.errors.messages}, status: :unprocessable_entity
    end
  end

  private

    def set_user
      redirect_to root_path, notice: t('access_denied') unless current_user.id == params[:id].to_i
      @user = current_user
      @settings = @user.settings
    end
end
