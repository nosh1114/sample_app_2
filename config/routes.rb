Rails.application.routes.draw do
  get 'relationships/follow'
  get 'relationships/unfollow'
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  get  '/signup', to: 'users#new'
  # /helpにGETリクエストが来たら、static_pagesコントローラーのhelpメソッドを実行
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/login',   to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  # login時、login後の内容変更時も必要。
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  get '/microposts', to: 'static_pages#home'
end
