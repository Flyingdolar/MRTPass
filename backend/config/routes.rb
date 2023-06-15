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
      resources :station do
        resources :time_table
        get 'time_table_search' => 'time_table#time_table_search'
        get 'line'=>'station#show_line'
      end
      resources :line
      resources :ticket, except: [:update,:delete]
      resources :lost
      delete 'ticket' => 'ticket#destroy'
      get 'price_search' => 'ticket#price_search'
      get 'line_station' => 'station#show_by_line'
      post 'common' => 'info#create_common'
      get 'common' => 'info#index_common'
      get 'common/:id' => 'info#show_common'
      patch 'common/:id' => 'info#update_common'
      delete 'info/:id' => 'info#destroy'

      post 'trans' => 'info#create_trans'
      get 'trans' => 'info#index_trans'
      get 'trans/:id' => 'info#show_trans'
      patch 'trans/:id' => 'info#update_trans'
    end
    namespace :member do
      resources :info, only: [] do
        resources :comment
      end      
    end
  end
end
