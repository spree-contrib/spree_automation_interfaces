require 'spec_helper'

describe 'Product Automated Translations', type: :feature, js: true do
  stub_authorization!

  let(:store) { Spree::Store.default }
  let(:product) { create(:product, stores: [store]) }

  context 'triggering automated translations' do
    before do
      store.update!(default_locale: 'en', supported_locales: 'en,fr')
    end

    context 'when automated translations are not configured' do
      before do
        allow(SpreeAutomationInterfaces::Dependencies).to receive(:products_automated_translations_provider).and_return(nil)
      end

      it "doesn't show automated translations button" do
        visit spree.admin_product_path(product)

        click_link 'Translations'

        expect(page).not_to have_button('Translate automatically')
      end
    end

    context 'when automated translations are configured' do
      before do
        allow(SpreeAutomationInterfaces::Dependencies).to receive_message_chain(:products_automated_translations_provider, :constantize, :new).and_return(translations_provider)
      end

      let(:translations_provider) { double }

      context 'when generating automated translations succeeds' do
        before do
          expect(translations_provider).to receive(:call).with(product: product, source_attributes: anything, source_locale: 'en', target_locale: 'fr').and_return({ name: new_translation })
        end

        let(:new_translation) { 'This is a test French translation' }

        it 'stores new translations' do
          visit spree.admin_product_path(product)

          click_link 'Translations'

          click_button 'Translate automatically'

          wait_for_turbo

          expect(product.translations.count).to eq(2)

          translation_fr = product.translations.find_by!(locale: 'fr')
          expect(translation_fr.name).to eq(new_translation)
        end
      end

      context 'when generating automated translations fails' do
        before do
          expect(translations_provider).to receive(:call).with(product: product, source_attributes: anything, source_locale: 'en', target_locale: 'fr').and_raise('Test error')
        end

        it 'shows an error' do
          visit spree.admin_product_path(product)

          click_link 'Translations'

          click_button 'Translate automatically'

          wait_for_turbo

          expect(page).to have_content('Test error')
        end
      end
    end
  end
end
