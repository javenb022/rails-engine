require "rails_helper"

RSpec.describe Item, type: :model do
  before :each do
    @merchant_1 = create(:merchant)
    @customer = create(:customer)

    @item_1 = @merchant_1.items.create(name: "Ring", unit_price: 100, description: "A ring")
    @item_2 = @merchant_1.items.create(name: "Turing", unit_price: 200, description: "A Turing")
    @item_3 = @merchant_1.items.create(name: "Necklace", unit_price: 300, description: "A necklace")

    @invoice = create(:invoice, customer: @customer, merchant: @merchant_1)
    @invoice_2 = create(:invoice, customer: @customer, merchant: @merchant_1)
    @invoice_3 = create(:invoice, customer: @customer, merchant: @merchant_1)

    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice)
    @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice)
    @invoice_item_3 = create(:invoice_item, item: @item_3, invoice: @invoice_2)
    @invoice_item_4 = create(:invoice_item, item: @item_3, invoice: @invoice_3)
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :merchant_id }
  end

  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe "class methods" do
    it "find_all" do
      expect(Item.find_all(name: 'ring')).to eq([@item_1, @item_2])
      expect(Item.find_all(min_price: 100, max_price: 200)).to eq([@item_1, @item_2])
      expect(Item.find_all(min_price: 100)).to eq([@item_1, @item_2, @item_3])
      expect(Item.find_all(max_price: 200)).to eq([@item_1, @item_2])
      expect(Item.find_all(name: '', min_price: nil, max_price: nil)).to eq(false)
    end

    it "search_by_name" do
      expect(Item.search_by_name('ring')).to eq([@item_1, @item_2])
    end

    it "find_by_price" do
      expect(Item.find_by_price(min_price: 100, max_price: 200)).to eq([@item_1, @item_2])
      expect(Item.find_by_price(min_price: 100)).to eq([@item_1, @item_2, @item_3])
      expect(Item.find_by_price(max_price: 200)).to eq([@item_1, @item_2])
    end

    # it "invoice_delete" do
    #   expect(Invoice.count).to eq(3)
    #   expect(InvoiceItem.count).to eq(4)

    #   @item_1.destroy
    #   require 'pry'; binding.pry
    #   expect(@item_1.invoice_delete).to eq([@invoice_2, @invoice_3])
    # end
  end
end