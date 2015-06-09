Rails.application.routes.draw do
  get '/', :to => 'homepage#index', :as => 'homepage'
  post '/shortener', :to => 'shortener#new', :as => 'shortener_new'
  get '/:id', :to => 'shortener/shortened_urls#show', :as => 'shortener_show'
end
