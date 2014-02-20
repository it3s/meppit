class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  def new
    @user = User.new
    render :layout => nil
  end

  def create
    # REFACTOR proper strong parameters and login after create
    @user = User.new(user_params)

    if @user.save
      # TODO login
      redirect_to root_path
    else
      render action: 'new'
    end
  end


  private

    # Only allow a trusted parameter "white list" through.
    def user_params
      params[:user]
    end
end
