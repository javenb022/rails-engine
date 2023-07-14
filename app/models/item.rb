class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :delete_all
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  validates :name, :description, :unit_price, :merchant_id, presence: true#, allow_blank: false


  def self.find_all(name: nil, min_price: nil, max_price: nil)
    if name.present? && name != '' && min_price.nil? && max_price.nil?
      Item.find_by_name(name)
    elsif name.nil? && (min_price.to_f.positive? || max_price.to_f.positive?)
      Item.find_by_price(min_price:, max_price:)
    else
      false
    end
  end

  def self.search_by_name(name)
    Item.where("name ILIKE ?", "%#{name}%").order(:name).first
  end

  def self.find_by_price(min_price: nil, max_price: nil)
    min_price = min_price.present? ? min_price: 0
    max_price = max_price.present? ? max_price: 999_999
    Item.where("unit_price BETWEEN ? AND ?", min_price, max_price)
  end

  def invoice_delete
    Invoice.left_joins(:invoice_items).group(:id).having('COUNT(invoice_items.id) = 0').destroy_all
  end
end
