TmCard::Application.routes.draw do

  get '/home/dialog_banner'
  get '/home/dialog_music'
  resources :site_images do 
    collection {post :sort}
  end

  resources :members do
    collection{get :new_token}
    collection{post :verify_token}
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
  match '/s-:site_id(/p-:id)', to: "s#index", via: :get
  match '/portfolio(/page/:page)', to: "home#portfolio", via: :get, as: 'portfolio'
  match '/search(/page/:page)', to: "home#search", via: :get, as: 'search'
  match '/case(/page/:page)', to: "home#case", via: :get, as: 'case'
  match '/blog(/page/:page)', to: "home#blog", via: :get, as: 'blog'
  match '/post/:id', to: "home#post", via: :get, as: 'post'
  match '/pricing', to: "home#pricing", via: :get, as: 'pricing'
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end