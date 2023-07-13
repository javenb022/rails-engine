class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :delete_all
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  validates :name, :description, :unit_price, :merchant_id, presence: true#, allow_blank: false

  def self.search_by_name(name)
    Item.where("name ILIKE ?", "%#{name}%").order(:name).first
  end

  def invoice_delete
    Invoice.left_joins(:invoice_items).group(:id).having('COUNT(invoice_items.id) = 0').destroy_all
  end
end
