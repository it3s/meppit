class UsersController < ApplicationController
  def new
    @user = User.new
    render :layout => nil if request.xhr?
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_welcome_email
      render :json => { :redirect => created_user_path }
    else
      render :json => { :errors => @user.errors.messages.to_json }, :status => :unprocessable_entity
    end
  end

  def created
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation, :license_aggrement)
  end
end
