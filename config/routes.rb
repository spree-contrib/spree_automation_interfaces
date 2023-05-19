Spree::Core::Engine.add_routes do
  namespace :admin, path: Spree.admin_path do
    resources :products do
      member do
        patch :translate
      end
    end
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v2 do
      namespace :platform do
        resources :products do
          member do
            patch :translate
          end
        end
      end
    end
  end
end