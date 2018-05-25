class AddFieldsToPaymentInvoice < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_requests, :montant_total_ht, :decimal
    add_column :payment_requests, :montant_total_tva, :decimal
    add_column :payment_requests, :montant_total_ttc, :decimal
  end
end
