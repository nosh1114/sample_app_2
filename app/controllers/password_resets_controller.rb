class PasswordResetsController < ApplicationController
  before_action :get_user, only:[:edit, :update]
  before_action :valid_user, only:[:edit, :update]
  before_action :check_expiration, only: [:edit, :update] 
  def new
    
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent password reset instructions"
      redirect_to root_path
    else
      flash.now[:danger] = "Email address not found"
      render 'new', status: :unprocessable_entity
    end
  end

  def edit    
  end

  def update
    # allow_nilにしたのでチェックする必要がある。
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit', status: :unprocessable_entity
    elsif @user.update(user_params)
      @user.forget
      reset_session
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "password has been reset."
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end

    end
  end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    # この時点でparamsは、reset_tokenが入っていることになる。
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def check_expiration
    # パスワードの期限が切れているか確認。
    if @user.password_reset_expired?
      # フラッシュに挿入する。
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end

end
