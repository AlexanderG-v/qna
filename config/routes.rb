Rails.application.routes.draw do
  use_doorkeeper
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      delete :cancel_vote
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, except: :index, concerns: [:votable] do
      post :best_answer, on: :member
      resources :comments, defaults: { commentable: 'answer' }
    end
    resources :comments, defaults: { commentable: 'question' }
  end

  resources :users, only: :show_rewards do
    get :show_rewards, on: :member
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  namespace :api do
    namespace :v1 do
      resources :users, only: :index do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show] do
        resources :answers, only: :index, shallow: true
      end
    end
  end

  get '/email', to: 'users#email'
  post '/set_email', to: 'users#set_email'

  mount ActionCable.server => '/cable'
end
