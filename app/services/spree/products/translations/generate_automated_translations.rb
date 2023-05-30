module Spree
  module Products
    module Translations
      class GenerateAutomatedTranslations

        # Initializes a new GenerateAutomatedTranslations object
        #
        # @param [_AutomatedTranslationsProvider] provider Translations provider
        # The provider object should respond to a call method, with the following parameters:
        # - source_attributes: Hash<String, String>
        # - source_locale: String
        # - target_locale: String
        # The provider object should return an instance of Hash, that provides translated attributes
        #
        # @example
        #
        #  class TranslationApiProvider
        #    def call(source_attributes:, source_locale:, target_locale:)
        #      translated_name = client.translate(source_attributes['name'], source_locale, target_locale)
        #      translated_desc = client.translate(source_attributes['description'], source_locale, target_locale)
        #      {
        #        name: translated_name,
        #        description: translated_desc
        #      }
        #    end
        #  end
        #
        #  Spree::Products::Translations::GenerateAutomatedTranslations.new(provider: TranslationApiProvider.new)
        #
        def initialize(provider: self.class.injected_automated_translations_provider)
          raise ArgumentError, 'Automated translations service not available' if provider.nil?

          @automated_translations_provider = provider
        end

        # Fetches translations using provider and updates the product
        #
        # @param [Spree::Product] product Product to generate translations for
        # @param [String] source_locale The locale that the product should be translated from
        # @param [Array<String>] target_locales A list of locales that the product should be translated to
        # @param [Boolean] skip_existing If set to true, it won't overwrite existing translations
        # @example
        #
        #  generate_automated_translations.call(
        #    product: product_to_translate,
        #    source_locale: 'en',
        #    target_locales: ['de', 'fr'],
        #    skip_existing: false
        #  )
        #
        def call(product:, source_locale:, target_locales:, skip_existing: true)
          raise ArgumentError, 'No locales available to translate to' if target_locales.empty?

          source_attributes = fetch_attributes_in_source_locale(product, source_locale)

          Spree::Product.transaction do
            translations_to_generate(product, target_locales, skip_existing).each do |target_locale|
              translate_to_locale(product, source_attributes, source_locale, target_locale)
            end
          end

          true
        end

        private

        attr_reader :automated_translations_provider

        def fetch_attributes_in_source_locale(product, source_locale)
          product.translations.find_by!(locale: source_locale).attributes
        end

        def translate_to_locale(product, source_attributes, source_locale, target_locale)
          translated_attributes = automated_translations_provider.call(source_attributes: source_attributes,
                                                                       source_locale: source_locale,
                                                                       target_locale: target_locale)

          translation = product.translations.find_or_initialize_by(locale: target_locale)
          translation.update!(translated_attributes)
        end

        def translations_to_generate(product, target_locales, skip_existing)
          return target_locales unless skip_existing

          target_locales - product.translations.pluck(:locale)
        end

        class << self
          # Determines whether a default translations provider is configured
          # @return [Boolean] true if SpreeAutomationInterfaces::Dependencies.products_automated_translations_provider is configured
          def default_provider_configured?
            injected_automated_translations_provider.present?
          end

          # Fetches a default translations provider object
          # @return [_AutomatedTranslationsProvider] default translations provider, if configured
          def injected_automated_translations_provider
            SpreeAutomationInterfaces::Dependencies.products_automated_translations_provider&.constantize&.new
          end
        end
      end
    end
  end
end