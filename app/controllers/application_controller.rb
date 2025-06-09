class ApplicationController < ActionController::Base
  # sessions周りのログイン機構はどの部分でも使うことになるので、全クラスの親クラスに読み込ませ、どこでも読み込ませられるようにする。
  include SessionsHelper
  def logged_in_user
    unless logged_in?
      store_location
      # ログインしていない場合は、ログインページにリダイレクト
      flash[:danger] = "Please log in."
      redirect_to login_url, status: :see_other
    end
  end
end
