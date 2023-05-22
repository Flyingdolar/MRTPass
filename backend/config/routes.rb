Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :admin do
    end
    namespace :mrt_admin do
      resources :station
    end
    namespace :member do
    end
  end
end
