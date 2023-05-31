Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  post 'sign_in'  => 'account#new_session'
  post 'sign_up'  => 'account#create'
  get  'session'  => 'account#get_session'
  post 'sign_out' => 'account#delete'
  patch 'update'  => 'account#update'
  patch 'password'=> 'account#update_pswd'
  namespace :api do
    namespace :admin do
      resources :authorization, except: [:create]
    end
    namespace :mrt_admin do
      resources :announcement
      resources :station
      get 'line_station' => 'station#show_by_line'
      post 'common' => 'info#create_common'
      get 'common' => 'info#index_common'
      get 'common/:id' => 'info#show_common'
      patch 'common/:id' => 'info#update_common'
      delete 'common/:id' => 'info#destroy'

      post 'trans' => 'info#create_trans'
      get 'trans' => 'info#index_trans'
      get 'trans/:id' => 'info#show_trans'
      patch 'trans/:id' => 'info#update_trans'
      delete 'trans/:id' => 'info#destroy'
    end
    namespace :member do
      resources :info, only: [] do
        resources :comment
      end      
    end
  end
end
