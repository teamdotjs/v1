Rails.application.routes.draw do
  resources :sentences
  resources :word_roots
  resources :lessons
  resources :courses
  resources :words
  devise_for :users
  resources :users, :controller => 'users'
  root 'static_pages#home'
end
