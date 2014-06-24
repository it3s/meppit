class FollowingsController < ApplicationController
  before_action :require_login, :find_followable

  def create
    @followable.add_follower current_user
    render json: {ok: true}
  end

  def destroy
    @followable.remove_follower current_user
    render json: {ok: true}
  end

  private

  def find_followable
    @followable = find_polymorphic_object
  end
end
