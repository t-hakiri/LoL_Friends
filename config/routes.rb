Rails.application.routes.draw do
  root 'toppage#toppage'
  devise_for :users, controllers: {
  sessions: 'users/sessions',
  registrations: 'users/registrations'
  }

  resources :groups, shallow: true do
    resources :group_messages, only: [:create, :destroy, :index]
    member do
      patch 'change_approval_system'
    end
  end
  resources :join_groups

  resources :conversations, shallow: true do 
    get :mail_box, on: :member
    resources :messages
  end

  resources :judgements, only: :create do 
    get :join_group_permission, on: :member
    get :join_group_deny, on: :member
  end 
  
  resources :boards, shallow: true do
    resources :responses
  end

  get 'search', to: 'summonersearches#search'
  # get 'searchs', to: 'summonersearches#index'
  get 'user_search', to: 'users#user_search'
  get 'my_group', to: 'users#my_group'

  devise_scope :user do
    get "user/:id", :to => "users/registrations#detail", as: :user
  # get "signup", :to => "users/registrations#new"
  # get "login", :to => "users/sessions#new"
  # get "logout", :to => "users/sessions#destroy"
  end

  resources :relationships, only: [:create, :destroy, :index]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  mount ActionCable.server => '/cable'
end