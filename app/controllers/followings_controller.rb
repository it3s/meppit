class FollowingsController < ApplicationController
  before_action :require_login, :find_followable

  def create
    follow_button_json_response @followable.add_follower(current_user)
  end

  def destroy
    follow_button_json_response @followable.remove_follower(current_user)
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
end
