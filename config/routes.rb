Rails.application.routes.draw do
  match '*path', to: 'proxy#get', via: :get
  match '*path', to: 'proxy#post', via: :post
end
