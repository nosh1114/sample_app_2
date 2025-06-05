class SessionsController < ApplicationController
  # GETリクエスト
  def new; end

  # POSTリクエスト
  def create
    # userは存在しない場合もある。nilガードをチェックするべき。
    # sessionが入っていなければこうなる。
    user = User.find_by(email: params[:session][:email])
    # 片方失敗したらだめ。左がダメになれば、即座にfalse
    if user && user.authenticate(params[:session][:password])
      # ログイン成功
      # セッションをリセットする。セッションハイジャック対策。
      # セッションハイジャックとは、セッションIDを盗まれて、他人にログインされること。
      # reset_session
      if user.activated?
        forwarding_url = session[:forwarding_url]
        # ログインの直前に必ずこれを書くこと
        # 永続的セッションのためにユーザーをデータベースに記憶する
        # forgetがある理由としては、別の端末からログインして、その際remember_meを外したとすると、
        # 端末Aでは、remembertokenAを持っている。端末Bでは、remembertokenはない。
        # 質問
        # ここで、forgetをするのは、端末AにもRememberMeがoffになったというようにするため。
        # current_userを取得する際の仕様がremember_digestがない時はログインできないようにしている仕様のため。
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)      
        log_in user
        redirect_to forwarding_url || user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
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
