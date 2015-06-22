Rails.application.routes.draw do
  devise_for :users
  get '/', :to => 'homepage#index', :as => 'homepage'
  post '/shortener', :to => 'shortener#new', :as => 'shortener_new'
  get '/shortener/list', :to => 'shortener#list', :as => 'shortener_list'
  get '/shortener/:unique_key', :to => 'shortener#details', :as => 'shortener_details'
  get '/:id', :to => 'shortener/shortened_urls#show', :as => 'shortener_show'
end
