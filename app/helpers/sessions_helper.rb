module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

    # 永続的セッションのためにユーザーをデータベースに記憶する
  def remember(user)
    # remember_tokenを生成して、remember_digestの値をuserにセットする。
    user.remember
    # user_id がそのまま入りそうに思えるが、encryptedにすることで、暗号化して保存できる。
    # permanentとは、ブラウザを閉じてもセッションが維持されることを意味する。
    cookies.permanent.encrypted[:user_id] = user.id
    # permanentメソッドとは？
    cookies.permanent[:remember_token] = user.remember_token
  end

  # userを返す
  def current_user
    # そもそもsession[:user_id]がnilなら、falseで次の処理
    if (user_id = session[:user_id])
      # @current_userが存在していれば、そのまま@current_userを返す。
      # もし@current_userが存在しなければ、User.find_byでDBから取得する。
      @current_user ||= User.find_by(id: user_id) 
    # cookiesに暗号化されたuser_idがあればこちらの処理
    elsif (user_id = cookies.encrypted[:user_id])
      raise
      @current_user = login_with_remember_token(user_id)
    end
  end

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
  # もうログインしている？
  def logged_in?
    !current_user.nil?
  end

    # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end


  def log_out
    # セッションをリセットする。セッションハイジャック対策。
    forget(current_user)
    reset_session
    @current_user = nil
  end
end
