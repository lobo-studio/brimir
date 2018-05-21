class ChangeQuantityType < ActiveRecord::Migration[5.1]
  def change
    change_column(:invoice_items, :quantity, :float)
  end
end
