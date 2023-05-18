Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  post 'sign_in'  => 'account#new_session'
  post 'sign_up'  => 'account#create'
  get  'session'  => 'account#get_session'
  post 'sign_out' => 'account#delete'
  patch 'update'  => 'account#update'
  namespace :api do
    namespace :admin do
    end
    namespace :mrt_admin do
      post 'announcement' => 'announce#create'
      get 'announcement' => 'announce#show_all'
      get 'announcement/:id' => 'announce#show_one'
      patch 'announcement/:id' => 'announce#edit'
      delete 'announcement/:id' => 'announce#delete'
      resources :station
    end
    namespace :member do
    end
  end
end
