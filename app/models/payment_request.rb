class PaymentRequest < ApplicationRecord
  belongs_to :ticket
  enum status: [:pending, :failed, :paid]
end
