class Item < ApplicationRecord
  belongs_to :merchant
  # has_many :invoice_items
  # has_many :invoices, through: :invoice_items
  # has_many :transactions, through: :invoices
  validates :name, :description, :unit_price, presence: true, allow_blank: false

  def self.search_by_name(name)
    Item.where("name ILIKE ?", "%#{name}%").order(:name).first
  end

  def self.search
end
