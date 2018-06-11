Brimir::Application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth' }

  resources :users do
    get :tickets, to: 'tickets#index'
  end

  namespace :tickets do
    resource :deleted, only: :destroy, controller: :deleted
    resource :selected, only: :update, controller: :selected
  end

  #resources :payment_requests,  only: [:new, :create, :show]
  
  #get '/invoices/:id/payment' => 'payment_requests#new', as: :new_payment
  #post '/invoices/:id/payment' => 'payment_requests#create', as: :payment_requests
  
  resources :payment_requests,  only: [:new, :create, :show]

  #get '/payment_requests/callback' => 'payment_requests#callback'

  resources :tickets, except: [:destroy, :edit] do
    resources :invoices,  only: [:new, :create, :show]
    resources :invoice_items
    
    resource :lock, only: [:destroy, :create], module: :tickets
  end

  resources :labelings, only: [:destroy, :create]

  resources :rules

  resources :email_templates

  resources :labels, only: [:destroy, :update, :index, :edit]

  resources :replies, only: [:create, :new, :update, :show]

  get '/attachments/:id/:format' => 'attachments#show'
  resources :attachments, only: [:index, :new]

  resources :email_addresses
  resources :email_imports, only: [:new, :create]

  resource :settings, only: [:edit, :update]

  root to: 'tickets#index'

  namespace :api do
    namespace :v1 do
      resources :tickets, only: [ :index, :show, :create ]
      resources :sessions, only: [ :create ]
      resources :users, param: :email, only: [ :create, :show ] do
        resources :tickets, only: [ :index ]
      end
    end
  end

  # Custom

  #root 'payment_requests#new'
  #post '/email_processor' => 'griddler/emails#create'
  mount_griddler
end
