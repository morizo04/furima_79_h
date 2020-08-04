Rails.application.routes.draw do
  root 'items#index'
  resources :items do
    collection do
      get "buy", to: "items#buy"
      get 'category/get_category_children', to: 'items#get_category_children', defaults: { format: 'json' }
      get 'category/get_category_grandchildren', to: 'items#get_category_grandchildren', defaults: { format: 'json' }
    end
    # 本来はメンバーでやりたのだが現状はidがないのでコレクションでビューを確認
    # member do
    #   get "buy", to: "items#buy"
    # end
resources :credit_card, only: [:create, :show, :edit] do
  collection do
    post 'delete', to: 'credit_card#delete'
    post 'show'
  end
  member do
    get 'confirmation'
     end
    end 
  end
end