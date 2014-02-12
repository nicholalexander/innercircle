Innercircle::Application.routes.draw do

get 'signup', to: "users#new", as: "signup"
get 'login', to: "sessions#new", as: "login" 
get 'logout', to: "sessions#destroy", as: "logout" 

resources :users
resources :photos do
  resources :comments, only: [:create, :destroy]
end

namespace :admins do
  get '/', to: "admins#index"
  get 'signup', to: "admins#new", as: "signup"
  get 'login', to: "sessions#new", as: "login" 
  get 'logout', to: "sessions#destroy", as: "logout" 

  post 'post', to: "sessions#create"

  get 'destroy_all', to: "admins#destroy_all"

  resources :users, only: [:update, :edit, :destroy]
  resources :photos, only: [:update, :edit, :destroy]
  resources :comments, only: [:update, :edit, :destroy]
  # resources :sessions
end

resources :sessions

root "welcome#index"
  
end
