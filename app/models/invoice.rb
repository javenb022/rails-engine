class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items, dependent: :delete_all
  has_many :items, through: :invoice_items

  validates :status, :customer_id, :merchant_id, presence: true#, allow_blank: false
end
