module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    # そもそもsession[:user_id]がnilなら、current_userはnil
    if session[:user_id]
      # @current_userが存在していれば、そのまま@current_userを返す。
      # もし@current_userが存在しなければ、User.find_byでDBから取得する。
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # もうログインしている？
  def logged_in?
    !current_user.nil?
  end

  def log_out
    # セッションをリセットする。セッションハイジャック対策。
    reset_session
    @current_user = nil
  end
end
