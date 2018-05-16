class AddAmountToPaymentRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_requests, :amount, :decimal
  end
end
