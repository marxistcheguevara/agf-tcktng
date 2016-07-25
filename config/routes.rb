Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :cashiers,
             path: "cashier",
             controllers:
                 {
                     sessions: 'cashiers/sessions'
                 },
             path_names:
                 {
                     sign_in: 'login',
                     sign_out: 'logout',
                     password: 'secret',
                     confirmation: 'verification',
                     unlock: 'unblock',
                     registration: 'register',
                     sign_up: 'registers'
                 }

  get 'cashier/sell_ticket/(:event_id)' => 'cashier_panel#sell_ticket'
  get 'cashier' => 'cashier_panel#sell_ticket'
  get 'cashier/my_tickets' => 'cashier_panel#my_tickets'
  get 'cashier/ticket/show/:id' => 'ticket_pdf#show'

  get 'cashier/unavailable_seats/:event_id/:sector_id' => 'cashier_panel#unavailable_seats'
  get 'cashier/selected_seats/:event_id' => 'cashier_panel#selected_seats'
  get 'cashier/bron_seats/:event_id' => 'cashier_panel#bron_seats'

  get 'cashier/invoices' => 'cashier_panel#invoices'
  get 'cashier/invoice/:id' => 'cashier_panel#invoice'
  get 'cashier/invoicepdf/:id' => 'ticket_pdf#invoice'

  get 'cashier/report' => 'cashier_panel#report'


  post 'cashier/sell_tickets' => 'cashier_panel#save_tickets'
  post 'cashier/sell_tickets/invitation' => 'cashier_panel#save_tickets', :defaults => { :invitation => true }
  post 'cashier/sell_tickets/discount' => 'cashier_panel#save_tickets', :defaults => { :discount => true }
  post 'cashier/bron_tickets' => 'cashier_panel#bron_tickets'
  post 'cashier/select_seat' => 'cashier_panel#select_seat'
  post 'cashier/unsell_seat' => 'cashier_panel#unsell_seat'

  post 'cashier/mySelectedSeats' => 'cashier_panel#my_selected_seats'
  post 'cashier/clearSelected' => 'cashier_panel#clear_selected'
  get 'cashier/showSeatDetails/:event_id/:seat_id' => 'cashier_panel#show_seat_details'
  get 'cashier/showSectorDetails/:event_id/:sector_id' => 'cashier_panel#show_sector_details'
  post 'checkout/approved' => 'main#approved'
  get 'seat_map/:sector_id/:event_id' => 'stadium#seat_map'
  root 'main#index'
  post 'online/buy_tickets' => 'main#save_tickets'

  get '/selling_seat/:event_id/:seat_id' => 'main#get_selling_seat'

  get '/online/:event_id/sectors' => 'main#sectors'

  scope "/:locale", locale: :en do
    get '/' => 'main#index'
    get '/buy-tickets/checkout-modal.html' => 'main#checkout_modal'
    get 'competition/:id' => 'main#competition'
    get 'event' => 'main#event'
    get 'show' => 'ticket_pdf#show'
    get 'buyTickets/:event_id' => 'main#buy_tickets'
    get 'event/:event_id' => 'main#event'
    get '/terms' => 'main#terms'
    post '/buy-tickets/checkout/:event_id' => 'main#checkout'
  end
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
