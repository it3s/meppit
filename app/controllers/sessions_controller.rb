class SessionsController < ApplicationController

  def create
    user = login(params[:email], params[:password])
    if user
      render :json => { :redirect => root_path }
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
    elsif (user = User.find_by(email: params[:email])) && user.activation_state == 'pending'
      t('sessions.create.pending')
    else
      t('sessions.create.invalid')
    end
  end
end
