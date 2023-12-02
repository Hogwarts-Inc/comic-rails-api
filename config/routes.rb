# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      resources :chapters
      resources :canvas
      resources :storiettes
      resources :characters
      resources :descriptions
      resources :conventions
      resources :likes
      resources :opinions
      resources :user_profiles, only: [:create] do
        patch :update_profile, on: :collection
      end
      resources :graphic_resources do
        collection do
          get :resource_for_type
        end
      end
    end
  end

  root to: 'admin/dashboard#index'
end
