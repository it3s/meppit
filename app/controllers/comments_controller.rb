class CommentsController < ApplicationController

  before_action :require_login, only: [:create]
  before_action :find_commentable

  def create
    comment = Comment.new comment_params
    if comment.valid? # comment.save
      render json: {flash: flash_xhr(t 'comments.saved'), comment_html: ""}
    else
      render json: {errors: comment.errors.messages}, status: :unprocessable_entity
    end
  end

  def index
    render nothing: true
  end

  private

    def find_commentable
      @commentable ||= find_polymorphic_object
    end

    def comment_params
      {user: current_user, content: @commentable, comment: params[:comment][:comment]}
    end

end
