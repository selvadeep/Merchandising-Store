Rails.application.routes.draw do
  resources :products do
    collection do 
      post :search
      post :items_price
      post :items_discounted_price
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
