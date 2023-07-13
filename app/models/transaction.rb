class Transaction < ApplicationRecord
  belongs_to :invoice

  validates_presence_of :credit_card_number, :result, :invoice_id, :credit_card_expiration_date
end
