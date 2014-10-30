class FlagsController < ApplicationController
  before_action :require_login
  before_action :find_flaggable, only: [:create]

  def new
    @flag = Flag.new
    render layout: nil if request.xhr?
  end

  def create
    @flag = Flag.new flag_params
    if @flag.valid? && @flag.save
      # EventBus.publish "flagged", flag: @flag
      flash[:notice] = t('flags.message_sent')
      render json: {redirect: polymorphic_path([@flaggable])}
    else
      render json: {errors: @flag.errors.messages}, status: :unprocessable_entity
    end
  end

  private

    def find_flaggable
      resource, id = URI(request.referer).path.split('/')[1..2]
      _model = resource.classify.constantize
      @flaggable = _model.find(id)
    end

    def flag_params
      params.require(:flag).permit(:comment, :reason).merge(user: current_user, flaggable: @flaggable)
    end

end
