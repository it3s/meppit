class UsersController < ApplicationController
  def new
    @user = User.new
    render :layout => nil if request.xhr?
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      render :json => { :redirect => created_users_path }
    else
      render :json => { :errors => @user.errors.messages.to_json }, :status => :unprocessable_entity
    end
  end

  def created
  end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      # redirect_to(login_path, :notice => 'User was successfully activated.')
      redirect_to root_url
    else
      not_authenticated
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation, :license_aggrement)
  end
end
