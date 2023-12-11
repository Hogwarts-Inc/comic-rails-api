# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      resources :chapters do
        member do
          get :check_queue
        end
      end
      resources :canvas
      resources :storiettes
      resources :characters
      resources :descriptions
      resources :conventions
      resources :likes
      resources :opinions
      resources :user_profiles, only: [:create] do
        collection do
          patch :update_profile
          get :canvas
          get :info
        end
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
