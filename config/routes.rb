Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  devise_for :users

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
    end
  end

  resources :users, only: :show_rewards do
    get :show_rewards, on: :member
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  mount ActionCable.server => '/cable'
end
