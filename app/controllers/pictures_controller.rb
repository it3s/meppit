class PicturesController < ApplicationController
  before_action :require_login, only: [:upload]
  before_action :find_object

  def upload
    @picture = Picture.new picture_params

    if @picture.valid? && @picture.save
      # EventBus.publish "??_updated", picture: picture, current_user: current_user, changes: {'picture'=>[]}
      render json: success_json
    else
      render json: {errors: @picture.errors.messages}, status: :unprocessable_entity
    end
  end

  def show
    render json: {}
  end

  private

    def success_json
      {image_url: @picture.image.url, show_url: url_for([@object, @picture]), flash: flash_xhr(t "flash.file_uploaded")}
    end

    def picture_params
      { image: params[:picture], author: current_user, object: @object }
    end

    def find_object
      @object = find_polymorphic_object
    end
end
