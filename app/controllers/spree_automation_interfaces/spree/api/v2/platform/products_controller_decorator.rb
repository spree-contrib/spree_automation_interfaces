module SpreeAutomationInterfaces
  module Spree
    module Api
      module V2
        module Platform
          module ProductsControllerDecorator
            def translate
              return render_error_payload(I18n.t(:missing_provider, scope: 'spree.automated_translations')) unless automated_translations_service.default_provider_configured?

              automated_translations_service.new.call(
                product: resource,
                source_locale: current_store.default_locale,
                target_locales: current_store.supported_locales_list - [current_store.default_locale],
                skip_existing: true
              )

                render_serialized_payload { { message: I18n.t(:success, scope: 'spree.automated_translations') } }
            rescue => e
              render_error_payload(e)
            end

            private

            def automated_translations_service
              SpreeAutomationInterfaces::Dependencies.products_generate_automated_translations.constantize
            end
          end
        end
      end
    end
  end
end

::Spree::Api::V2::Platform::ProductsController.prepend(SpreeAutomationInterfaces::Spree::Api::V2::Platform::ProductsControllerDecorator)