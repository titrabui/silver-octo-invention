Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'refresh', controller: :refresh, action: :create
  post 'signin', controller: :signin, action: :create
  post 'signup', controller: :signup, action: :create
  delete 'signin', controller: :signin, action: :destroy
  resources :oauth do
    collection do
      post 'google'
    end
  end

  resources :users
  get 'me', controller: :users, action: :me
  post 'upload', controller: :users, action: :upload

  namespace :admin do
    resources :users, only: [:index, :update, :destroy]
  end

  resources :password_resets, only: [:create] do
    collection do
      get ':token', action: :edit, as: :edit
      patch ':token', action: :update
    end
  end

  resources :posts
  get 'posts_by_user', controller: :posts, action: :posts_by_user

  resources :comments
  get 'comments_by_post', controller: :comments, action: :comments_by_post
  get 'replies/:id', controller: :comments, action: :comments_by_parent
end
