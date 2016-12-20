require 'rails_helper'

RSpec.describe PaymentsController, :type => :controller do
  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns a payment token to @client_token' do
      expect(Braintree::ClientToken).to receive(:generate).and_return("your_client_token")
      get :new
      expect(assigns(:client_token)).to be_a(String)
    end
  end
end
