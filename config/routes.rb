Rails.application.routes.draw do
  resources :roboscout_queries do
    member do
      get 'people'
    end
  end
  resources :people
  resources :publications
  # Leave this here to help deploy your app later!
  get "*path", to: "fallback#index", constraints: ->(req) { !req.xhr? && req.format.html? }
end
