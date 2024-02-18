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
          get :user_position_in_queue
          get :remove_user_from_queue
          get :last_three_canvas
          get :add_user_to_queue
        end
      end
      resources :canvas do
        member do
          delete :remove_like
        end
      end
      resources :storiettes
      resources :characters
      resources :descriptions
      resources :conventions
      resources :likes, except: [:destroy, :update]
      resources :opinions, except: [:destroy, :update]
      resources :terms_and_conditions
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

  namespace :admin do
    resources :storiettes do
      member do
        get 'export_images_to_zip'
        get 'export_images_to_pdf'
      end
    end
  end

  root to: 'admin/dashboard#index'
end
