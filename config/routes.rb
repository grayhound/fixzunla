Rails.application.routes.draw do
  get '/', :to => 'homepage#index', :as => 'homepage'
end
