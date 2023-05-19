require 'spree/core/dependencies_helper'

module SpreeAutomationInterfaces
  class AutomationInterfacesDependencies
    INJECTION_POINTS_WITH_DEFAULTS = {
      products_generate_automated_translations: 'Spree::Products::Translations::GenerateAutomatedTranslations',
      products_automated_translations_provider: nil
    }

    include Spree::DependenciesHelper
  end
end