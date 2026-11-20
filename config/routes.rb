Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  root "products#index"
  resources :products, only: %i[index show]
  resources :categories, only: %i[show]
  get "pages/:slug", to: "pages#show", as: :page

  get "up" => "rails/health#show", as: :rails_health_check
end