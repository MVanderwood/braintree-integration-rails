require 'rails_helper'
require 'support/mock_data'

RSpec.describe PaymentsController, :type => :controller do
  include_context 'mock_data'

  describe 'GET #show' do
    let(:transaction_id) { "my_id" }
    it 'assigns a transaction to @transaction' do
      expect(Braintree::Transaction).to receive(:find).with(transaction_id).and_return(mock_transaction)
      process :show, method: :get, params: { id: transaction_id }
      expect(assigns(:transaction)).to eq(mock_transaction)
    end

    it 'assigns a payment message to @message' do
      expect(Braintree::Transaction).to receive(:find).with(transaction_id).and_return(mock_transaction)
      process :show, method: :get, params: { id: transaction_id }
      expect(assigns(:message)).to be_a(Hash)
    end

    it 'renders the show template' do
      expect(Braintree::Transaction).to receive(:find).with(transaction_id).and_return(mock_transaction)
      process :show, method: :get, params: { id: transaction_id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      process :new, method: :get
      expect(response).to render_template(:new)
    end

    it 'assigns a payment token to @client_token' do
      expect(Braintree::ClientToken).to receive(:generate).and_return("your_client_token")
      process :new, method: :get
      expect(assigns(:client_token)).to be_a(String)
    end
  end

  describe 'POST #create' do
    let(:valid_nonce) { "fake-valid-nonce" }
    let(:invalid_nonce) { "not-a-valid-nonce"}

    let(:base_params) do
      { amount: 10.00, options: { submit_for_settlement: true} }
    end

    let(:valid_payment_params) { base_params.merge(payment_method_nonce: valid_nonce) }
    let(:invalid_payment_params) { base_params.merge(payment_method_nonce: invalid_nonce) }

    context 'transaction processed' do
      it 'receives a SuccessfulResult object from Braintree' do
        expect(Braintree::Transaction).to receive(:sale).with(valid_payment_params).and_return(
          Braintree::SuccessfulResult.new(transaction: mock_transaction)
        )
        process :create, method: :post, params: { "payment-method-nonce" => valid_nonce }
      end

      it 'assigns the transaction to @transaction' do
        expect(Braintree::Transaction).to receive(:sale).with(valid_payment_params).and_return(
          Braintree::SuccessfulResult.new(transaction: mock_transaction)
        )
        process :create, method: :post, params: { "payment-method-nonce" => valid_nonce }
        expect(assigns(:transaction)).to eq(mock_transaction)
      end

      it 'assigns a payment message to @message' do
        expect(Braintree::Transaction).to receive(:sale).with(valid_payment_params).and_return(
          Braintree::SuccessfulResult.new(transaction: mock_transaction)
        )
        process :create, method: :post, params: { "payment-method-nonce" => valid_nonce }
        expect(assigns(:message)).to be_a(Hash)
      end

      it 'renders the show template' do
        expect(Braintree::Transaction).to receive(:sale).with(valid_payment_params).and_return(
          Braintree::SuccessfulResult.new(transaction: mock_transaction)
        )
        process :create, method: :post, params: { "payment-method-nonce" => valid_nonce }
        expect(response).to render_template(:show)
      end
    end
    context 'transaction not processed' do
      it 'receives and ErrorResult object from Braintree' do
        expect(Braintree::Transaction).to receive(:sale).with(invalid_payment_params).and_return(
          error_result
        )
        process :create, method: :post, params: { "payment-method-nonce" => invalid_nonce }
      end

      it 'sets payment errors to a flash message' do
        expect(Braintree::Transaction).to receive(:sale).with(invalid_payment_params).and_return(
          error_result
        )
        process :create, method: :post, params: { "payment-method-nonce" => invalid_nonce }
        expect(flash[:errors]).to eq(["Error 91565: Unknown payment_method_nonce."])
      end

      it 'redirects to the #new action' do
        expect(Braintree::Transaction).to receive(:sale).with(invalid_payment_params).and_return(
          error_result
        )
        process :create, method: :post, params: { "payment-method-nonce" => invalid_nonce, "x" => true }
        expect(response).to redirect_to(action: :new)
      end
    end
  end
end
