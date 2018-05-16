module PaymentRequestsStrongParams
  extend ActiveSupport::Concern
  protected
  def payment_request_params
    params.require(:payment_request).permit(
      :amount
    )
  end
end
