Spabooker::Application.routes.draw do

  
  


  resources :manage_leaves do
    member do
      put :update_status
    end

    collection do
      delete 'delete_selected'
    end
  end

  get "payments/index"

  get "hr_system/index"

  #  match 'leave_applications/manage_leaves', :to => 'leave_applications#manage_leaves', :via => "get"
  #  match 'leave_applications/delete_selected', :to => 'leave_applications#delete_selected'
  resources :payments do
    member do
      get "update_service_packages"
      put :update_status
    end

    collection do
      get "cash_register"
      post "new_entry"
      get 'search_cash_register'
    end

  end
  resources :gift_vouchers


  #  resources :hr_system do
  #    collection do
  #      post 'search'
  #      delete 'delete_selected'
  #      get :manage_leaves
  #    end
    
  #  end

  resources :sub_categories

  resources :payments

  resources :categories do
    member do
      post "add_sub_category"
      delete "delete_sub_category"
      get 'get_sub_categories'
    end
  end

  resources :services do
    member do
      get 'update_service_rates'
      delete "delete_selected_option"
    end

    collection do
      delete 'delete_selected'
      post "search"
    end
  end

  

  root :to => "guests#index"
  get "users/new"

 
  resources :appointments do
    collection do
      get 'appointments_by_date'
    end

    collection do
      get 'calendar'
      post "search"
    end

    member do
      get 'invoice'
      get 'print_invoice'
      post 'appointment_payment'
    end

  end

  resources :guests do
    member do
      put :update_status
      put :update_custom_field
      delete :destroy_custom_field
      get :appointments
      get :notes
      post :create_note
      delete :delete_note
      put :update_field
      get :purchases
    end
    collection do
      delete 'delete_selected'
      post 'csv_import'
      get 'csv_guest_form'
      get 'search'
      get :export_to_xls
      get :export_to_csv
      get :export_pdf
      get 'filter_guest'
      get :custom_fields
      post :create_custom_field
      post :change_custom_field_name
      post :change_custom_field_type
      get 'get_empty_csv'
      get 'guest_custom_field'
      
    end
  end

  resources  :events do
    member do
      post 'resize'
      post 'move'
    end

    collection do
      get 'get_events'
    end
  end

  resources :roles do
    collection do
      delete 'delete_selected'
      get 'search'
    
      #      get 'manage_role'
    end

    member do
      put :update_status
      put 'assign_permission'
    end
  end



  resources :permissions

  resources :user_sessions

  resources :users do
    collection do
      get 'manage_role'
      get 'new_user'
      post 'create_user'
    end

  
    member do
      put :update_name
      #      get 'new_user'
      #            post 'create_user'
    end
  end
  
  resources :packages do
    member do
      put :update_status
   
    end
    collection do
      delete 'delete_selected'
      post 'search'
    end
  end

  resources :password_resets, :only => [ :new, :create, :edit, :update ]

  resources :locations do
    collection do
      delete 'delete_selected'
      post 'search'
      get 'get_outlets'
    end
    member do
      put :update_status
      get :get_operation_hours
      post :create_operation_hours
      get :show_operation_hours_on_date
      put :update_operation_time
      get :closed_dates
      get :new_closed_date
      post :add_closed_date
      get :edit_closed_date
      put :update_closed_date
      delete :delete_closed_date
    end
  end


  resources :equipments do
    collection do
      delete 'delete_selected'
      post 'search'
      put 'update_location_equipment_status'
    end
    member do
      put :update_status
    end
  end

  resources :employees do
    resources :leave_applications
    collection do
      delete 'delete_selected'
      post 'search'
    end
    member do
      put "update_status"
      get :assign_role
    end
  end

  resources :rooms do
    collection do
      delete 'delete_selected'
      post 'search'
      
    end
    member do
      put :update_status
    end
  end

  resources :taxtypes do
    collection do
      delete 'delete_selected'
      post 'search'
    end
    member do
      put :update_status
    end
  end

  resources :memberships do
    collection do
      delete 'delete_selected'
      post 'search'
    end
    member do
      put :update_status
    end

  end

  resources :products do
    collection do
      delete 'delete_selected'
      post 'search'
    end
    member do
      put :update_status
    
      get "update_sub_categorie_products"
    end
    resources :inventories
  end

  resources :profiles do

    collection do
      delete 'delete_selected'
      post 'csv_import'
      get 'csv_profile_form'
      get :export_to_csv
      get :export_to_xls
      get :export_pdf
      post 'search'
      get 'get_empty_csv'
    end
    member do
      put :update_status
    end
  end


  #  resources :events
  #  match "/guests" => "users#index", :as => :guests
  match 'login' => "user_sessions#new",      :as => :login
  match 'logout' => "user_sessions#destroy", :as => :logout
  match 'signup' => "users#new", :as=>:signup
  #  match 'new_user' => "users#new", :as => :new_user
  #    match 'create_user' => "users#create", :as => :create_user
  match 'account' => "users#account", :as=>:account
  match 'activate/:activation_code' => "users#activate", :as =>:activate


  
  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end