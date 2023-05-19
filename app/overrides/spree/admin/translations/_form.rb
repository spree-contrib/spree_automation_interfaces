Deface::Override.new(
  virtual_path: 'spree/admin/translations/_form',
  name: 'Enable admin to automatically translate products',
  insert_before: "[data-hook='translations_form']",
  text: <<-HTML
          <% if resource.is_a?(Spree::Product) && SpreeAutomationInterfaces::Dependencies.products_generate_automated_translations&.constantize&.default_provider_configured? %>
            <%= button_to(I18n.t(:translate, scope: 'spree.automated_translations'), translate_admin_product_path(resource), method: :patch, class: 'btn btn-primary') %>
          <% end %>
        HTML
)