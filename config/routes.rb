Rails.application.routes.draw do
  devise_for :users

  concern :voting do
    post :vote_for, :vote_against, :vote_revoke, on: :member
  end

  concern :commenting do
    post :make_comment, on: :member
  end

  resources :users do
    resources :rewards, shallow: true, only: [:index]
  end

  resources :questions, concerns: [:voting, :commenting] do
    resources :answers, concerns: [:voting, :commenting], shallow: true do
      member do
        patch :right_answer
        patch :not_right_answer
      end
    end
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy, :update]

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
