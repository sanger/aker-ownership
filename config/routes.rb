Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :ownerships, param: :model_id

  post 'ownerships/batch' => 'ownerships#create_batch'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


end
