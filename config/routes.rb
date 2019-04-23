Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', confirmations: 'confirmations' }
  devise_scope :users do
    get 'profile', to: 'users#profile'
  end

  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  concern :voting do
    post :vote_for, :vote_against, :vote_revoke, on: :member
  end

  resources :users do
    resources :rewards, shallow: true, only: [:index]
  end

  resources :questions, concerns: [:voting] do
    resources :comments, only: [:create]
    resources :answers, concerns: [:voting], shallow: true do
      resources :comments, only: [:create]
      member do
        patch :right_answer
        patch :not_right_answer
      end
    end
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy, :update]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :all_users, on: :collection
      end
      resources :questions do
        resources :answers
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
