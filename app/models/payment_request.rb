class PaymentRequest < ApplicationRecord
  belongs_to :ticket
  validates_presence_of :amount
  enum status: [:pending, :failed, :paid]
end
