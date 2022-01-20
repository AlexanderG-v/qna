Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  devise_for :users

  resources :questions do 
    resources :answers, shallow: true, except: :index do
      post :best_answer, on: :member
    end
  end

  resources :attachments, only: :destroy
end
