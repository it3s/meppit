class FollowingsController < ApplicationController
  before_action :require_login

  def create
    Following.create following_params
    render json: {ok: true}
  end

  def destroy
    following = Following.find_by(following_params)
    following.destroy if following
    render json: {ok: true}
  end

  private

  def following_params
    {followable_type: params[:followable_type], followable_id: params[:followable_id], follower: current_user}
  end
end
