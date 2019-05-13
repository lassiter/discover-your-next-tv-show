Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/search', action: :search, controller: 'search'
  resources :home_page, only: [:index]
  mount ActionCable.server => '/cable'
end
