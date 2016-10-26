Rails.application.routes.draw do
  resources :categories
  devise_for :users#generado por devise
  get 'welcome/index'
  #get "special", to: "welcome#index" #renombrar la ruta
  resources :articles do #NESTED RESOURCES- los comentarios dependen de los articulos
            resources :comments, only: [:create, :destroy, :update, :show]#NESTED RESOURCES- los comentarios dependen de los articulos. y q solo tenga las rutas de create...PARA EVITAR ACCEDER A LOS COMENTARIOS DE FORMA INDIVIDUAL POR LAS RUTAS puede ser only y except
          end
   #get "special", to: "articles#index" #renombrar la ruta

  #=begin     estos son los ejemplos de las rutas generadas con el resource automaticamente
    #get "/articles" index
    #post "/articles" create
    #delete "/articles/:id" destroy
    #get "/articles/:id" show
    #get "/articles/new" new
    #get "/articles/:id/edit" edit
    #patch "/articles/:id" update
    #put "/articles/:id" update
  #=end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'welcome#index'

   get "/dashboard", to: "welcome#dashboard"

   put "/articles/:id/publish", to: "articles#publish" #es con put ya que mediante esta accion vamos a modificar un registro

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
