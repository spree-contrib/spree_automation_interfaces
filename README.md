# SpreeAutomationInterfaces

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

4. Configure provider

config/initializers/spree_automation_interfaces.rb

```ruby
Rails.application.config.after_initialize do
   SpreeAutomationInterfaces::Dependencies.products_automated_translations_provider = 'MyAutomatedTranslationsProvider'
end
```

5. Once configured, go to the translations tab in the admin panel - it will now display a button for triggering automated translations.

Copyright (c) 2023 Upside Lab sp. z o.o., released under the New BSD License
