class SessionsController < ApplicationController

  def oauth_login
    render layout: 'clean'
  end

  def new
  end

  def create
    if user = login(params[:email], params[:password], to_bool(params[:remember_me]))
      set_logged_in_cookie
      respond_to do |format|
        format.html { render :json => { redirect: login_redirect_path } }
        format.json { render :json => { redirect: login_redirect_path } }
      end
    else
      render :json => { errors: error_message }, status: :unprocessable_entity
    end
  end

  def destroy
    destroy_logged_in_cookie
    logout
    redirect_to root_url, notice: t('sessions.flash.logout')
  end

  private

    def error_message
      if params[:email].blank? || params[:password].blank?
        t('sessions.create.blank')
      elsif (user = User.find_by(email: params[:email])) && user.activation_state == 'pending'
        t('sessions.create.pending')
      else
        t('sessions.create.invalid')
      end
    end
end
