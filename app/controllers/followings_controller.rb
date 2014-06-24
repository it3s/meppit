class FollowingsController < ApplicationController
  layout :followings_layout

  before_action :require_login, except: [:followers, :following]
  before_action :find_followable

  def create
    follow_button_json_response @followable.add_follower(current_user)
  end

  def destroy
    follow_button_json_response @followable.remove_follower(current_user)
  end

  def followers
    @followers = paginate @followable.followers
  end

  def following
    @following = paginate @followable.followed_objects
  end

  private

  def find_followable
    @followable = find_polymorphic_object
  end

  def follow_button_json_response(action_result)
    if action_result
      render json: {ok: true, following: current_user.follow?(@followable)}
    else
      render json: {ok: false}, status: :unprocessable_entity
    end
  end

  def paginated collection
    collection = Kaminari.paginate_array collection if collection.kind_of? Array
    collection.page(params[:page]).per(params[:per])
  end

  def followings_layout
    polymorphic_layout @followable
  end
end
