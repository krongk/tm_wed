TmCard::Application.routes.draw do

  resources :resource_musics

  namespace :app do
    get "site/new"
    post "site/create"
    get "site/ajax_get_member"
    get "site/preview"
  end
  
  get '/home/dialog_banner'
  get '/home/dialog_music'
  resources :site_images do 
    collection {post :sort}
    collection {get :app}
    collection {get :meitu_load}
    collection {post :meitu_upload}
  end

  resources :members do
    collection {get :new_token}
    collection {post :verify_token}
  end

  resources :site_comments #for show on client
  resources :site_pages

  resources :sites do 
    resources :site_steps
    resources :site_comments #for admin manage
    collection do
      post :send_sms
    end
    get 'preview'
    get 'themes'
    get 'payment'
    post 'set_theme'
    post 'verify_payment_token'
    post :alipay_notify
  end
  namespace :sites do
    post "temp_form_update"
  end
  
  match '/s-:site_id(/p-:id)', to: "s#index", via: :get
  match '/templates(/page/:page)', to: "home#templates", via: :get, as: 'templates'
  match '/templates/:id', to: "home#template", via: :get, as: 'template'
  match '/search(/page/:page)', to: "home#search", via: :get, as: 'search'
  match '/case(/page/:page)', to: "home#case", via: :get, as: 'case'
  match '/top(/:q)(/page/:page)', to: "home#top", via: :get, as: 'top'
  match '/biz(/page/:page)', to: "home#biz", via: :get, as: 'biz'
  match '/blog(/page/:page)', to: "home#blog", via: :get, as: 'blog'
  match '/post/:id', to: "home#post", via: :get, as: 'post'
  match '/pricing', to: "home#pricing", via: :get, as: 'pricing'
  match '/vip', to: "home#vip", via: :get, as: 'vip'
  root :to => "home#index"

  devise_for :users, :controllers => {:registrations => "registrations", omniauth_callbacks: "omniauth_callbacks"}

  resources :users
end