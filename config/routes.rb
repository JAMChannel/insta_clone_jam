require 'sidekiq/web'

Rails.application.routes.draw do

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
    mount Sidekiq::Web, at: '/sidekiq'
  end

  resources :chatrooms, only: %i[index create show], shallow: true do
    resources :messages
  end
  
  namespace :mypage do
    get 'activities/index'
  end
  root 'posts#index'

  resources :users, only: %i[index new create show]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resources :posts, shallow: true do
    collection do
      get :search
    end
    resources :comments
  end
  resources :likes, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
  resources :activities, only: [] do
    patch :read, on: :member
  end

  namespace :mypage do
    resource :account, only: %i[edit update]
    resources :activities, only: %i[index]
    resource :notification_setting, only: %i[edit update]
  end
end
