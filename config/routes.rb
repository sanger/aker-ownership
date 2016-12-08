Rails.application.routes.draw do
  resources :ownerships, param: :model_id
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
