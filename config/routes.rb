Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "prototypes#index"
  get "/prototypes", to: "prototypes#index"
  get "/prototypes/artist", to: "prototypes#artist"
  get "/prototypes/album", to: "prototypes#album"
  get "/prototypes/login", to: "prototypes#login"
  get "/prototypes/register", to: "prototypes#register"
  get "/prototypes/profile", to: "prototypes#profile"

end
