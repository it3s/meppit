class SessionsController < ApplicationController

  def new
  end

  def create
    user = login(params[:email], params[:password], to_bool(params[:remember_me]))
    if user
      render :json => { :redirect => session[:return_to_url] || request.env['HTTP_REFERER'] || root_path }
      session[:return_to_url] = nil
    else
      render :json => { :errors => error_message }, :status => :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => t('sessions.flash.logout')
  end

  private

  def error_message
    if params[:email].blank? || params[:password].blank?
      t('sessions.create.blank')
    elsif (user = User.find_by(:email => params[:email])) && user.activation_state == 'pending'
      t('sessions.create.pending')
    else
      t('sessions.create.invalid')
    end
  end
end
