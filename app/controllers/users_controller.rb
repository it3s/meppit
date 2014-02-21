class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  def new
    @user = User.new
    render :layout => nil
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(user_params[:email], user_params[:password])
      render :json => { :redirect => root_path }
    else
      render :json => { :errors => @user.errors.messages.to_json }, :status => :unprocessable_entity
    end
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
        :password_confirmation, :license_aggrement)
    end
end
