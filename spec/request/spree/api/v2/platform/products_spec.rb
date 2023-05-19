require 'spec_helper'
require 'spree/api/testing_support/v2/platform_contexts'

describe 'API V2 Platform Products Automation Interfaces Spec', type: :request do
  include_context 'Platform API v2'
  let(:bearer_token) { { 'Authorization' => valid_authorization } }
  let(:product) { create(:product, stores: [store]) }

  describe 'products#translate' do
    subject { patch "/api/v2/platform/products/#{product.id}/translate", headers: bearer_token }

    before do
      allow_any_instance_of(Spree::Api::V2::Platform::ProductsController).to receive(:current_store).and_return(store)
    end

    let(:store) { create(:store, default_locale: 'en', supported_locales: 'en,fr' ) }

    context 'when automated translations are not configured' do
      before do
        allow(SpreeAutomationInterfaces::Dependencies).to receive(:products_automated_translations_provider).and_return(nil)
        subject
      end

      it_behaves_like 'returns 422 HTTP status'

      it 'returns error message' do
        expect(json_response['error']).to eq('No automated translations provider configured')
      end
    end

    context 'when automated translations are configured' do
      before do
        allow(SpreeAutomationInterfaces::Dependencies).to receive_message_chain(:products_automated_translations_provider, :constantize, :new).and_return(translations_provider)
      end

      let(:translations_provider) { double }

      context 'when generating automated translations succeeds' do
        before do
          expect(translations_provider).to receive(:call).with(product: product, source_attributes: anything, source_locale: 'en', target_locale: 'fr').and_return({ name: 'FR Name' })
          subject
        end

        it_behaves_like 'returns 200 HTTP status'

        it 'returns status' do
          expect(json_response['message']).to eq('Requested translations were generated successfully')
        end
      end

      context 'when generating automated translations fails' do
        before do
          expect(translations_provider).to receive(:call).with(product: product, source_attributes: anything, source_locale: 'en', target_locale: 'fr').and_raise('Test error')
          subject
        end

        it_behaves_like 'returns 422 HTTP status'

        it 'returns error' do
          expect(json_response['error']).to eq('Test error')
        end
      end
    end
  end
end