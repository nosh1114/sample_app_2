module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    session[:session_token] = user.session_token
  end

  # cookiesにuserの情報を渡す。
  def remember(user)
    # remember_tokenを生成して、remember_digestの値をuserにセットする。
    user.remember
    # user_id がそのまま入りそうに思えるが、encryptedにすることで、暗号化して保存できる。
    # permanentとは、ブラウザを閉じてもセッションが維持されることを意味する。
    cookies.permanent.encrypted[:user_id] = user.id
    # permanentメソッドとは？
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 現在ログインしているuserを取得するメソッド。
  def current_user
    # そもそもsession[:user_id]がnilなら、falseで次の処理
    # すでにログインしているタイミング。
    # session[:user_id]があれば、user_idにセットする。
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)
      # userが存在していて、かつsession[:session_token]がuserのsession_tokenと一致していれば、
      # @current_userにuserをセットする。
      if user &&  session[:session_token] == user.session_token
        @current_user = user
      end
      # @current_userが存在していれば、そのまま@current_userを返す。
      # もし@current_userが存在しなければ、User.find_byでDBから取得する。
    # cookiesに暗号化されたuser_idがあればこちらの処理
    elsif (user_id = cookies.encrypted[:user_id])
      @current_user = login_with_remember_token(user_id)
    end
  end

  def current_user?(user)
    user && user == current_user
  end

  # 少しネストしていたので、リファクタリング
  def login_with_remember_token(user_id)
    user = User.find_by(id: user_id)
    # userが存在していて、かつcookieのパスワードがあればuserとしてlogin
    if user && user.authenticated?(:remember, cookies[:remember_token])
      log_in user
      user
    else
      nil
    end
  end
  # もうログインしている？viewで使う用。
  def logged_in?
    !current_user.nil?
  end

  # cookiesの情報を削除する。
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # ログアウトする。
  def log_out
    # セッションをリセットする。セッションハイジャック対策。
    forget(current_user)
    reset_session
    @current_user = nil
  end

  def store_location
    # リクエストがGETメソッドであれば、現在のURLをセッションに保存する。
    session[:forwarding_url] = request.original_url if request.get?
  end
end
