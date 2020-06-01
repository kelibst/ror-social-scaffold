Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users

  resources :users, only: [:index, :show,:destroy] do
    member do
      match 'send_req' => 'users#req_init', via: [:get]
      match 'delete_req' => 'users#destroy_req', via: [:delete]
    end
  end
  resources :posts, only: [:index, :create] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
