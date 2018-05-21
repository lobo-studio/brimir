class RemoveAmount < ActiveRecord::Migration[5.1]
  def change
    remove_column :invoice_items, :amount
  end
end
