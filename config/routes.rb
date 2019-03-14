Rails.application.routes.draw do
  devise_for :users

  concern :voting do
    post :vote_for, :vote_against, :vote_revoke, on: :member
  end

  resources :users do
    resources :rewards, shallow: true, only: [:index]
  end

  resources :questions, concerns: :voting do
    resources :answers, shallow: true do
      member do
        patch :right_answer
        patch :not_right_answer
      end
    end
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy, :update]

  root to: 'questions#index'
end
