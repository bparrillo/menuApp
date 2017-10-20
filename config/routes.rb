Rails.application.routes.draw do
  resources :menu_items

  get '/menu_item/submit_order', to: 'menu_items#submit_order'
  get '/menu_item/confirm_order', to: 'menu_items#confirm_order'
  post '/menu_item/finalize_order', to: 'menu_items#finalize_order'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
