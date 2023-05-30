# Spree Automation Interfaces

Spree Automation Interfaces is a gem that extends the functionality of the Spree ecommerce framework by providing an interface for automating certain actions. This package allows you to easily integrate and automate various tasks within your Spree-based application.

## Features

- Automated Translations: With Spree Automation Interfaces, you can seamlessly trigger automated translations using a third-party provider. This enables you to localize your Spree store and reach a wider audience without manual intervention.


## Installation

1. Add this extension to your Gemfile with this line:

    ```ruby
    gem 'spree_automation_interfaces'
    ```

2. Install the gem using Bundler

    ```ruby
    bundle install
    ```

3. Restart your server

## Configuring providers

### Automated Product Translations

1. Create a provider implementation, that translates the attributes that it receives.

```ruby
class MyTranslationsProvider
  def call(source_attributes:, source_locale:, target_locale:)
    translated_name = client.translate(source_attributes['name'], source_locale, target_locale)
    translated_desc = client.translate(source_attributes['description'], source_locale, target_locale)
    {
      name: translated_name,
      description: translated_desc
    }
  end
   
  private 
   
  def client
    # Your translations API client
  end
end
```
   
The provider receives three arguments:
- source_attributes - a Hash of product's attributes in the source_locale
- source_locale - the locale to translate the attributes from
- target_locale - the locale to translate the attributes to

The provider should return a Hash containing the attributes to be updated, translated to the target_locale.

2. Set the provider as the default one:

In an initializer e.g. `config/initializers/spree_automation_interfaces.rb` add the following:

```ruby
Rails.application.config.after_initialize do
   SpreeAutomationInterfaces::Dependencies.products_automated_translations_provider = 'MyAutomatedTranslationsProvider'
end
```

3. Restart the application

4. Go to the "Translations" tab in product's admin panel - it will now display a button for triggering automated translations.

Copyright (c) 2023 Upside Lab sp. z o.o., released under the New BSD License
