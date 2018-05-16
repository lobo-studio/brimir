class AddTitleToInvoiceItem < ActiveRecord::Migration[5.1]
  def change
    add_column :invoice_items, :title, :string
  end
end
