Rails.application.routes.draw do

  resources :stubs

  root 'stubs#index'

  match '*path', to: 'proxy#get', via: :get
  match '*path', to: 'proxy#post', via: :post
end
