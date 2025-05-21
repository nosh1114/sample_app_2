Rails.application.routes.draw do
  # コントローラー名/メソッド
  get 'static_pages/home'
  get 'static_pages/help'
  root "hello#index"
end
