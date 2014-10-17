class CommentsController < ApplicationController

  before_action :require_login
  before_action :find_commentable
  after_action  :publish_commented_event

  def create
    @comment = Comment.new comment_params
    if @comment.save
      render json: {flash: flash_xhr(t 'comments.saved'), comment_html: comment_html}
    else
      render json: {errors: @comment.errors.messages}, status: :unprocessable_entity
    end
  end

  private

    def find_commentable
      @commentable ||= find_polymorphic_object
    end

    def comment_params
      {user: current_user, content: @commentable, comment: params[:comment][:comment]}
    end

    def comment_html
      render_to_string(partial: 'comments/comment', locals: {comment: @comment})
    end

    def publish_commented_event
      if response.ok?
        EventBus.publish "commented", object: @commentable, current_user: current_user, changes: {'comment' => @comment.comment}
      end
    end

end
