Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    member do
      delete :delete_file    
    end
    resources :answers, shallow: true do
      member do
        patch :right_answer
        patch :not_right_answer
        delete :delete_file
      end
    end
  end

  root to: 'questions#index'
end
