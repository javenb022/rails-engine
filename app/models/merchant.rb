class Merchant < ApplicationRecord
  has_many :items

  validates :name, presence: true#, allow_blank: false


  def self.find_by_name(name)
    Merchant.where("name ILIKE ?", "%#{name}%").order(:name).first
  end
end
