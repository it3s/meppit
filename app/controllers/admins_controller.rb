class AdminsController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :is_current_user, only: [:show]
  before_action :find_flags,      only: [:show]
  before_action :find_deletable,  only: [:confirm_deletion, :delete_object]

  def show
  end

  def confirm_deletion
    render layout: nil if request.xhr?
  end

  def delete_object
    @deletable.destroy
    flash[:info] = t('admin.deleted', name: @deletable.name)
    redirect_to root_path
  end

  protected

    def find_flags
      @unsolved_flags = Flag.includes(:flaggable, :user).unsolved
      @solved_flags = Flag.includes(:flaggable, :user).solved
    end

    def is_current_user
      redirect_to(root_path, notice: t('access_denied')) if params[:id].to_i != current_user.id
    end

    def find_deletable
      @deletable = find_object_from_referer
    end
end


