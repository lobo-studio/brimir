class CreatePaymentRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_requests do |t|
      t.references :ticket, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
