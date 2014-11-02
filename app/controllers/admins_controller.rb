class AdminsController < ApplicationController
  before_action :require_login
  before_action :is_current_user
  before_action :require_admin
  before_action :find_flags,      only: [:show]

  def show
  end

  protected

    def find_flags
      @unsolved_flags = Flag.includes(:flaggable, :user).unsolved
      @solved_flags = Flag.includes(:flaggable, :user).solved
    end

    def is_current_user
      redirect_to(root_path, notice: t('access_denied')) if params[:id].to_i != current_user.id
    end
end


