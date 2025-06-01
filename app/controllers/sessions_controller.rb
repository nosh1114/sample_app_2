class SessionsController < ApplicationController
  # GETリクエスト
  def new; end

  # POSTリクエスト
  def create
    # userは存在しない場合もある。nilガードをチェックするべき。
    user = User.find_by(email: params[:session][:email])
    # 片方失敗したらだめ。左がダメになれば、即座にfalse
    if user && user.authenticate(params[:session][:password])
      # ログイン成功
      # セッションをリセットする。セッションハイジャック対策。
      # セッションハイジャックとは、セッションIDを盗まれて、他人にログインされること。
      reset_session # ログインの直前に必ずこれを書くこと
      log_in(user)
      redirect_to user
    else
      # リダイレクト後は消える。
      flash.now[:danger] = 'Invalid/email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    #  303として明示的にリダイレクトする。
    # 303は、POST・DELETEリクエストの後にGETリクエストを行うためのステータスコード。
    redirect_to root_url, status: :see_other
  end
end
