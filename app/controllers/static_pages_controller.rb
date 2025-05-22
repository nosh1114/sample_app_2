class StaticPagesController < ApplicationController
  def home
    # =>app/views/static_pages/home.html.erbが標準で表示される
    # render ...とすると、指定できる。
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
