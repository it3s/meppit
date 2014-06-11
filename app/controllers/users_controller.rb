class UsersController < ApplicationController
  include ContributorController
  include PasswordResets

  before_action :require_login,   :only => [:edit, :update]
  before_action :find_user,       :only => [:show, :edit, :update, :contributions]
  before_action :is_current_user, :only => [:edit, :update]

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
      render :json => { :errors => @user.errors.messages }, :status => :unprocessable_entity
    end
  end

  def created
  end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      redirect_to root_path, :notice => t('users.flash.activated')
    else
      flash[:error] = t('users.flash.activation_error')
      not_authenticated
    end
  end

  def show
  end

  def edit
  end

  def update
    update_object @user, user_params
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation,
                                 :license_aggrement, :about_me, :avatar).tap do |whitelisted|
      whitelisted[:contacts]  = (params[:user][:contacts]  || {}).delete_if { |key, value| value.blank? }
      whitelisted[:interests] = (params[:user][:interests] || '').split(',')
    end
  end

  def find_user
    @user = User.find(params[:id])
  end

  def is_current_user
    redirect_to(root_path, :notice => t('access_denied')) if @user != current_user
  end
end
