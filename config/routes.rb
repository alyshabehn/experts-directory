Rails.application.routes.draw do
  get 'friends/update'
  get 'members/index'

  resources :members do
    resources :friends
  end

  root 'members#index'
end
