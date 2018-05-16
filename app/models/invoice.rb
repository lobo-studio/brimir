class Invoice < ApplicationRecord
  include EmailMessage
  
  belongs_to :ticket
  has_many :invoice_items, inverse_of: :invoice
  accepts_nested_attributes_for :invoice_items, reject_if: :all_blank, allow_destroy: true
  validates_presence_of :customer_email, :customer_address

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true
end
