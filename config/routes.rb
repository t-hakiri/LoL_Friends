Rails.application.routes.draw do
  root 'toppage#toppage'
  devise_for :users, controllers: {
  sessions: 'users/sessions',
  registrations: 'users/registrations'
  }

  # devise_scope :user do
  # get "user/:id", :to => "users/registrations#detail"
  # get "signup", :to => "users/registrations#new"
  # get "login", :to => "users/sessions#new"
  # get "logout", :to => "users/sessions#destroy"
  # end
end