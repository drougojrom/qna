Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true do
      member do
        patch :right_answer
        patch :not_right_answer
      end
    end
  end

  root to: 'questions#index'
end
