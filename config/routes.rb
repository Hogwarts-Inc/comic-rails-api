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
      resources :chapters, only: [:index, :show, :create] do
        member do
          get :check_queue
          get :user_position_in_queue
          get :remove_user_from_queue
          get :last_three_canvas
          get :add_user_to_queue
        end
      end
      resources :canvas, only: [:index, :show, :create] do
        member do
          delete :remove_like
        end
      end
      resources :storiettes, only: [:index, :show]
      resources :characters, only: [:index, :show]
      resources :descriptions, only: [:index, :show]
      resources :conventions, only: [:index, :show]
      resources :likes, except: [:destroy, :update]
      resources :opinions, except: [:destroy, :update]
      resources :nft_transfers, only: [:create]
      resources :queue_times, only: [:index, :show] do
        collection do
          get :remove_user_time
        end
      end
      resources :terms_and_conditions, only: [:index, :show]
      resources :logos, only: [:index, :show]
      resources :user_profiles, only: [:create] do
        collection do
          patch :update_profile
          get :canvas
          get :info
        end
      end
      resources :graphic_resources, only: [:index, :show] do
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
