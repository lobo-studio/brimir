class ChangeStatusType < ActiveRecord::Migration[5.1]
  def change
    remove_column :payment_requests, :status
    add_column :payment_requests, :status, :integer
  end
end
