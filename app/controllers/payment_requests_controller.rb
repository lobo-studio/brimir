class PaymentRequestsController < ApplicationController
  include ApplicationHelper
  layout 'payment'
  before_action :authenticate_user!, except: [:callback, :new, :show, :create]
  load_and_authorize_resource :payment_request, except: [:callback, :new, :show, :create]
  skip_authorization_check only: [:callback, :new, :show, :create]

  TRANSACTION_SUCCESS_STATUSES = [
    Braintree::Transaction::Status::Authorizing,
    Braintree::Transaction::Status::Authorized,
    Braintree::Transaction::Status::Settled,
    Braintree::Transaction::Status::SettlementConfirmed,
    Braintree::Transaction::Status::SettlementPending,
    Braintree::Transaction::Status::Settling,
    Braintree::Transaction::Status::SubmittedForSettlement,
  ]

  def new
    find_invoice
    ticket = @invoice.ticket
    @amount = ticket.payment_requests.where(status: :pending).last.montant_total_ttc
    @client_token = gateway.client_token.generate
  end

  def show
    @transaction = gateway.transaction.find(params[:id])
    @result = _create_result_hash(@transaction)
  end

  def create
    find_invoice
    ticket = @invoice.ticket
    pr = ticket.payment_requests.where(status: :pending).last

    nonce = params["payment_method_nonce"]

    result = gateway.transaction.sale(
      amount: pr.montant_total_ttc,
      payment_method_nonce: nonce,
      :options => {
        :submit_for_settlement => true
      }
    )

    if result.success? #|| result.transaction
      pr.status = :paid
      pr.save
      InvoiceMailer.send_invoice(ticket, @invoice).deliver_now
      redirect_to payment_request_path(result.transaction.id)
    else
      error_messages = result.errors.map { |error| "Error: #{error.code}: #{error.message}" }
      flash[:error] = error_messages
      redirect_to new_payment_request_url(hash: secret_id(@invoice.id))
    end
  end

  def _create_result_hash(transaction)
    status = transaction.status

    if TRANSACTION_SUCCESS_STATUSES.include? status
      result_hash = {
        :header => "Success!",
        :icon => "success",
        :message => "Your transaction has been successfully processed."
      }
    else
      result_hash = {
        :header => "Failed",
        :icon => "fail",
        :message => "Your transaction has a status of #{status}. Please try again, and contact support"
      }
    end
  end

  def gateway
    env = ENV["BT_ENVIRONMENT"]

    @gateway ||= Braintree::Gateway.new(
      :environment => env && env.to_sym,
      :merchant_id => ENV["BT_MERCHANT_ID"],
      :public_key => ENV["BT_PUBLIC_KEY"],
      :private_key => ENV["BT_PRIVATE_KEY"],
    )
  end

  def find_invoice
    hash = params[:hash].scan(/../).map { |x| x.hex.chr }.join
    id_part = hash.split('_').last
    @invoice = Invoice.find(Base64.decode64(id_part))
  end
end
