Researchgr::Application.routes.draw do
  scope '(:locale)', locale: /en|gr/ do
    root 'static_pages#index'
    get '/:locale' => 'static_pages#index'

    resources :users do
      resources :projects
      resources :project_files
      resources :invitations, except: [:new, :show, :edit, :destroy]
      member do
        post :change_pass
      end
    end

    resources :projects do
      resources :invitations, except: [:new, :show, :edit, :destroy]
      resources :project_files do
        member do
          post :set_main
          get :get_file
          get :show_history
        end
      end
      resources :citations, only: :destroy
    end

    post '/check_login' => 'users#check_login'
    get '/activate' => 'users#activate'
    get '/forgot_pass' => 'users#forgot_pass'
    post '/pass_recover' => 'users#password_recovery'
    get '/logout' => 'users#logout'
    get '/users_autocomplete' => 'users#autocomplete'
    get '/invitations' => 'invitations#index'
    get '/search' => 'static_pages#search'
    get '/google_scholar/search_scholar' => 'google_scholar#search_scholar'
    get '/google_scholar/search_citation' => 'google_scholar#search_citation'
    get '/google_scholar/citation_save' => 'google_scholar#citation_save'

    # Open Search routes
    get '/open_search/list_sets/:repo' => 'open_search#list_sets'
    get '/open_search/list_records' => 'open_search#list_records'
    get '/open_search/get_record' => 'open_search#get_record'
    get '/open_search/cite_record' => 'open_search#cite_record'

    # IEEE Xplore routes
    get '/ieee/list_records' => 'ieee#list_records'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
