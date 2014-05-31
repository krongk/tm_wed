TmCard::Application.routes.draw do

  resources :site_images do 
    collection {post :sort}
  end

  resources :site_comments
  resources :site_pages
 
  resources :sites do 
    resources :site_steps  
    collection {post :send_sms}
  end
  namespace :sites do
    post "temp_form_update"
  end
  match '/s/:site_id(/p-:id)', to: "s#index", via: :get
  match '/portfolio(/page/:page)', to: "home#portfolio", via: :get, as: 'portfolio'
  match '/search(/page/:page)', to: "home#search", via: :get, as: 'search'
  match '/case(/page/:page)', to: "home#case", via: :get, as: 'case'
  match '/pricing', to: "home#pricing", via: :get, as: 'pricing'
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end