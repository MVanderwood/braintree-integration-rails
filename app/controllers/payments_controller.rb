class PaymentsController < ApplicationController
  def new
    @client_token = Braintree::ClientToken.generate
  end

  def create
  end
end
