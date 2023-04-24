Rails.application.routes.draw do
  get 'search_link/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'search_link#index'
  post '/search', to: 'search_link#search_exact'
end
