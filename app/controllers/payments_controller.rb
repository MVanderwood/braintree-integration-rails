class PaymentsController < ApplicationController
  TRANSACTION_SUCCESS_STATUSES = [
    Braintree::Transaction::Status::Authorizing,
    Braintree::Transaction::Status::Authorized,
    Braintree::Transaction::Status::Settled,
    Braintree::Transaction::Status::SettlementConfirmed,
    Braintree::Transaction::Status::SettlementPending,
    Braintree::Transaction::Status::Settling,
    Braintree::Transaction::Status::SubmittedForSettlement,
  ]

  def show
    @transaction = Braintree::Transaction.find(params[:id])
    @message = set_payment_message(@transaction)
  end

  def new
    @client_token = Braintree::ClientToken.generate
  end

  def create
    trans_result = Braintree::Transaction.sale(payment_params)
    # binding.pry if params["x"]
    if trans_result.success? || trans_result.transaction
      @transaction = trans_result.transaction
      @message = set_payment_message(@transaction)
      render :show
    else
      flash[:errors] = trans_result.errors.map do |err|
        "Error #{err.code}: #{err.message}"
      end
      redirect_to action: :new
    end
  end

  private

  def set_payment_message(transaction)
    if TRANSACTION_SUCCESS_STATUSES.include?(transaction.status)
      {
        status: "Success!",
        content: "Your test transaction has been successfully processed."
      }
    else
      {
        status: "Failure",
        content: "Your transaction has failed with a status of #{transaction.status}"
      }
    end
  end

  def payment_params
    {
      amount: 10.00,
      payment_method_nonce: params["payment-method-nonce"],
      options: { submit_for_settlement: true }
    }
  end
end
