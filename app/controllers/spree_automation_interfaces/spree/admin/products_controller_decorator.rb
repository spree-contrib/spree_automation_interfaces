module SpreeAutomationInterfaces
  module Spree
    module Admin
      module ProductsControllerDecorator
        def translate
          if automated_translations_service.default_provider_configured?
            begin
              automated_translations_service.new.call(
                product: @product,
                source_locale: current_store.default_locale,
                target_locales: current_store.supported_locales_list - [current_store.default_locale],
                skip_existing: true
              )

              flash[:message] = I18n.t(:success, scope: 'spree.automated_translations')
            rescue => e
              flash[:error] = e.message
            end
          else
            flash[:error] = I18n.t(:missing_provider, scope: 'spree.automated_translations')
          end
        ensure
          redirect_to translations_admin_product_path(@product)
        end

        # This is a workaround, as for some reason the 'translate' action doesn't show up in action_methods correctly.
        # This causes Rails to raise an error when calling it, saying that the controller doesn't respond to it.
        # We should look into it further.
        def action_missing(name)
          name == 'translate' ? translate : nil
        end

        private

        def automated_translations_service
          SpreeAutomationInterfaces::Dependencies.products_generate_automated_translations.constantize
        end
      end
    end
  end
end

::Spree::Admin::ProductsController.prepend(SpreeAutomationInterfaces::Spree::Admin::ProductsControllerDecorator)