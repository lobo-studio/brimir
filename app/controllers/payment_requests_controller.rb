class PaymentRequestsController < ApplicationController
 
  before_action :authenticate_user!, except: [:callback]
  load_and_authorize_resource :payment_request, except: :callback
  skip_authorization_check only: :callback

  def callback
  end

end
