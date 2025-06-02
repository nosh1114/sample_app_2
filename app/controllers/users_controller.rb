class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    # @は、インスタンス変数と呼ばれ、ビューで使用できるようにするために必要です。
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash.now[:success] = 'Welcome to the sameple app!いらっしゃい！'
      # redirect_to user_url(@user)やuser_path(@user)と同じ
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
