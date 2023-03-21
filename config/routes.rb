Rails.application.routes.draw do

  get '/search' => 'movies#search', as: :movies_search

  # Defines the root path route ("/")
  root "movies#index"
end
