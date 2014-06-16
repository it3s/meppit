class FollowingsController < ApplicationController
  layout :followings_layout

  before_action :require_login
  before_action :require_login, :find_followable

  def create
    follow_button_json_response @followable.add_follower(current_user)
  end

  def destroy
    follow_button_json_response @followable.remove_follower(current_user)
  end

  def followers
    @followers = paginated @followable.followers
  end

  def following
    @following = paginated @followable.followed_objects
  end

  private

  def find_followable
    @followable = find_polymorphic_object
  end

  def follow_button_json_response(action_result)
    if action_result
      render json: {ok: true}
    else
      render json: {ok: false}, status: :unprocessable_entity
    end
  end

  def paginated collection
    collection = Kaminari.paginate_array collection if collection.kind_of? Array
    collection.page(params[:page]).per(params[:per])
  end

  def followings_layout
    unless request.xhr? then @followable.class.name.pluralize.underscore else false end
  end
end
