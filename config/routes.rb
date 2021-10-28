Rails.application.routes.draw do
  get 'comments/edit'
  root 'posts#index'

  resources :users, only: %i[new create]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resources :posts, shallow: true do
    resources :comments
  end
  resources :likes, only: %i[create destroy]
end
