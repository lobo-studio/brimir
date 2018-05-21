class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  validates_presence_of :tax, :quantity, :unit_price, :title
end
