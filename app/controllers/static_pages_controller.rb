class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # micropost.newとしないのは、userとmicropostに紐づけるため。
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  # app/views/コントローラー名/メソッド名.html.erb
  def help
    # roots / rootは、ルートパスを指します。
    # routes / routeは、URLとコントローラーのアクションを結びつけるものです。
  end

  def about; end
  def contact;
  end
end
