class SessionsController < ApplicationController

  def create
    user = login(params[:email], params[:password])
    if user
      render :json => { :redirect => root_path }
    else
      # REFACTOR i18n
      render :json => { :error => "email or password invalid" },
             :status => :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_url
  end
end
