Rails.application.routes.draw do
  resources :tasks do
    post :reshuffle, on: :collection
    put :complete, on: :member
  end

  get '/login', to: 'signin#index', as: 'login'
  get '/logout', to: 'oauth_session#destroy'
  get '/auth/:provider/callback', to: 'oauth_session#create'
end
