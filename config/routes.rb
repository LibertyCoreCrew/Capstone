Rails.application.routes.draw do
  root 'pages#login'

  get '/login' => 'pages#login'

  get '/index' => 'pages#index'

  get '/admin' => 'pages#admin'

  get '/dashboard' => 'pages#dashboard'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
