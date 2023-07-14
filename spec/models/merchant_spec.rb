require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
  end

  describe "relationships" do
    it { should have_many :items }
  end

  describe "class methods" do
    it "find_by_name" do
      expected = create(:merchant, name: "Ring World")
      expect(Merchant.find_by_name("ring")).to eq(expected)
    end
  end
end