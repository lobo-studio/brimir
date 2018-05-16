class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.references :ticket, foreign_key: true
      t.text :customer_address
      t.string :customer_email
      t.date :invoice_date
      t.timestamps
    end
  end
end
