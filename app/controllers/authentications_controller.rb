class AuthenticationsController < ApplicationController
  skip_before_filter :require_login

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    add_provider unless @user = login_from(provider, true)
    redirect_to root_path, :notice => t('users.oauth.logged', :provider => provider.titleize)
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end

  def provider
    auth_params[:provider]
  end

  def add_provider
    add_provider_to_existent_user || create_user_from_provider

    reset_session # protect from session fixation attack
    auto_login(@user, true)
  end

  def add_provider_to_existent_user
    if @user = User.find_by(:email => @user_hash[:user_info]['email'])
      @current_user = @user
      add_provider_to_user(provider)
     end
  end

  def create_user_from_provider
    @user = create_from(provider)
    @user.activate!
  end

end
