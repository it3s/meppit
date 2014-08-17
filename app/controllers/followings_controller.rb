class FollowingsController < ApplicationController

  before_action :require_login, except: [:followers, :following]
  before_action :find_followable

  def create
    follow_button_json_response @followable.add_follower(current_user)
  end

  def destroy
    follow_button_json_response @followable.remove_follower(current_user)
  end

  def followers
    @followers ||= paginate @followable.followers
    render layout: nil if request.xhr?
  end

  def following
    @following ||= paginate @followable.following
    render layout: nil if request.xhr?
  end

  private

    def find_followable
      @followable = find_polymorphic_object
    end

    def follow_button_json_response(action_result)
      if action_result
        render json: {ok: true, following: current_user.follow?(@followable), count: @followable.followers_count}
      else
        render json: {ok: false}, status: :unprocessable_entity
      end
    end
end
