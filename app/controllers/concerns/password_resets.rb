module PasswordResets
  # TODO: TEST-ME
  extend ActiveSupport::Concern

  included do
    skip_before_filter :require_login, :only => [
      :new_password_reset, :create_password_reset,
      :edit_password, :update_password]

    before_action :load_user_from_token, :only => [:edit_password, :update_password]
  end

  def forgot_password
    render :layout => nil
  end

  def reset_password
    @user = User.find_by(:email => params[:email])
    @user.deliver_reset_password_instructions! if @user
    redirect_to root_path, :notice => t('users.forgot_password.email_sent')
  end

  def edit_password
  end

  def update_password
    @user.assign_attributes user_params
    if @user.valid?(:create) && @user.change_password!(user_params[:password])
      flash[:notice] = t('users.forgot_password.updated')
      render :json => {:redirect => root_path}
    else
      render :json => {:errors => @user.errors.messages}, :status => :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def load_user_from_token
    @token = params[:token]
    @user = User.load_from_reset_password_token(@token)

    return not_authenticated if @user.blank?
  end
end
