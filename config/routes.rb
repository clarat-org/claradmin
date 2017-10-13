# frozen_string_literal: true

Rails.application.routes.draw do
  # Devise
  devise_for :users, class_name: 'User'
  devise_scope :user do
    authenticated do
      root controller: :pages, action: :react
    end

    unauthenticated do
      root to: 'devise/sessions#new', as: 'unauthenticated_root'
    end
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # General Routes

  # shouldn't consider "new" to be a slug
  get 'organizations/new', controller: :pages, action: :react
  get 'offers/new', controller: :pages, action: :react

  # resources :organizations do
  #   collection do
  #     get 'export', controller: :pages, action: :react
  #   end
  # end
  #
  # resources :divisions, controller: :pages, action: :react do
  #   collection do
  #     get 'export', controller: :pages, action: :react
  #   end
  # end

  resources :categories do
    collection do
      get :sort
      get :mindmap
    end
  end

  # resources :offer_translations, only: [:index, :edit, :update] do
  #   collection do
  #     get 'export', controller: :pages, action: :react
  #   end
  # end
  # resources :offer_translations, only: [:show], controller: :pages, action: :react
  # resources :organization_translations, only: [:index, :edit, :update] do
  #   collection do
  #     get 'export', controller: :pages, action: :react
  #   end
  # end
  # resources :organization_translations, only: [:show], controller: :pages, action: :react
  # resources :statistic_charts
  # resources :users, only: [:index, :show], controller: :pages, action: :react
  # resources :user_teams, only: [:index, :show, :new, :edit],
  #                        controller: :pages, action: :react
  # resources :assignments, only: [:index, :show], controller: :pages, action: :react
  # get 'time_allocations(/:year/:week_number)', controller: :time_allocations,
  #                                              action: :index

  resources :next_steps_offers, only: [:index]

  # Export
  # get 'exports/:object_name/new', controller: :exports, action: :new,
  #                                 as: :new_export
  post 'exports/:object_name/', controller: :exports, action: :create,
                                as: :exports

  get 'categories/:offer_name/suggest_categories', controller: :categories,
                                                   action: :suggest_categories
  get 'next_steps_offers/:offer_id', controller: :next_steps_offers,
                                     action: :index
  put 'next_steps_offers/:id', controller: :next_steps_offers, action: :update

  # Stats
  # get '/statistics(/:subpage)' => 'statistics#index', as: :statistics
  # get '/statistics/:topic(/:user_id)' => 'statistics#show', as: :statistic

  # non-REST paths
  # ...
  get 'test' => 'pages#test'

  # API
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :categories do
        collection do
          put 'sort'
        end
      end
      def api_resources name, options = {}
        resources name, options.merge(path: name.to_s.dasherize)
      end
      api_resources :offers
      api_resources :split_bases
      api_resources :locations
      api_resources :organizations
      api_resources :divisions
      api_resources :statistics, only: [:index]
      api_resources :users, only: %i[index show update]
      api_resources :websites
      api_resources :offer_translations, only: %i[index show update]
      api_resources :organization_translations, only: %i[index show update]
      api_resources :statistic_charts, except: [:destroy]
      api_resources :time_allocations, only: %i[create update]
      api_resources :user_teams
      api_resources :openings
      api_resources :tags
      api_resources :definitions
      api_resources :solution_categories
      api_resources :sections, only: %i[index show]
      api_resources :subscriptions, only: %i[index show destroy]
      api_resources :update_requests, only: %i[index show]
      api_resources :cities, only: %i[index show]
      api_resources :areas, only: %i[index show]
      api_resources :topics, only: %i[index show]
      api_resources :federal_states, only: %i[index show]
      api_resources :contact_people
      api_resources :emails
      api_resources :filters, only: %i[index show]
      api_resources :target_audience_filters_offers, only: %i[index show]
      api_resources :next_steps
      api_resources :tags
      api_resources :logic_versions, only: %i[index show]
      api_resources :assignments, only: %i[index show create update]
      post 'time_allocations/:year/:week_number',  controller: :time_allocations,
                                                   action: :report_actual
      # get '/statistics/:topic/:user_id(/:start/:end)' => 'statistics#index'
      get 'field_set/:model', controller: :field_set, action: :show
      get 'possible_events/:model/:id', controller: :possible_events,
                                        action: :show
      get 'states/:model', controller: :states, action: :show
      get ':item_type/:item_id/versions', controller: :versions, action: :index
    end
  end

  # Sidekiq interface
  require 'sidekiq/web'
  require 'sidekiq-cron'
  require 'sidekiq/cron/web'
  constraint = lambda do |request|
    request.env['warden'].authenticate?
  end
  constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Forward every other page to react and let it deal with it
  match '*path', controller: :pages, action: :react, via: :all,
                 constraints: ->(request) { request.format == :html }
end
