class PicturesController < ApplicationController
  before_action :require_login,      only: [:upload]

  def upload
    puts "\nPARAMS\n#{params}\n"
    render json: { avatar: User.new.avatar.url }
    # @user.avatar = user_params[:avatar]
    # if @user.valid? && @user.save
    #   EventBus.publish "user_updated", user: @user, current_user: current_user, changes: {'avatar'=>[]}
    #   render json: {avatar: @user.avatar.url, flash: flash_xhr(t "flash.file_uploaded")}
    # else
    #   render json: {errors: @user.errors.messages}, status: :unprocessable_entity
    # end
  end
end
