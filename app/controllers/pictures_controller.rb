class PicturesController < ApplicationController
  before_action :require_login, only: [:upload]
  before_action :find_object

  def upload
    puts "\nPARAMS\n#{params}\n"
    puts @object
    render json: { url: User.new.avatar.url, flash: flash_xhr(t "flash.file_uploaded") }
    # @user.avatar = user_params[:avatar]
    # if @user.valid? && @user.save
    #   EventBus.publish "user_updated", user: @user, current_user: current_user, changes: {'avatar'=>[]}
    #   render json: {avatar: @user.avatar.url, flash: flash_xhr(t "flash.file_uploaded")}
    # else
    #   render json: {errors: @user.errors.messages}, status: :unprocessable_entity
    # end
  end

  private

    def find_object
      @object = find_polymorphic_object
    end
end
