class FlagsController < ApplicationController
  before_action :require_login
  before_action :find_flaggable,        only: [:create]
  after_action  :publish_flagged_event, only: [:create]
  before_action :require_admin,         only: [:mark_as_solved]

  def new
    @flag = Flag.new
    render layout: nil if request.xhr?
  end

  def create
    @flag = Flag.new flag_params
    if @flag.valid? && @flag.save
      flash[:notice] = t('flags.message_sent')
      render json: {redirect: polymorphic_path([@flaggable])}
    else
      render json: {errors: @flag.errors.messages}, status: :unprocessable_entity
    end
  end

  def mark_as_solved
    @flag = Flag.find params[:id]
    @flag.solved = true
    @flag.save
    redirect_to admin_user_path(current_user)
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

    def publish_flagged_event
      EventBus.publish "flagged", object: @flaggable, current_user: current_user, changes: {@flag.reason => ""} if response.ok?
    end
end
