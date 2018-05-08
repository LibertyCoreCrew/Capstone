Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  root 'pages#dashboard'

  get '/login' => 'pages#login'

  get '/index' => 'pages#index'

  get '/documents' => 'pages#documents'

  get '/admin' => 'pages#admin'

  get 'dashboard' => 'pages#dashboard'

  get '/tracts/:id' => 'tracts#show', as: 'tract'
  get '/projects/:id' => 'projects#show', as: 'project'
  get '/documentation', :to => redirect('/application.html')

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
