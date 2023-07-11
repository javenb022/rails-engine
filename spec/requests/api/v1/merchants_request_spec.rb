require "rails_helper"

RSpec.describe "Merchants API" do
  describe "GET /api/v1/merchants" do
    it "returns all merchants" do
      create_list(:merchant, 3)

      get "/api/v1/merchants"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(3)

      merchants.each do |merchant|
        expect(merchant[1][0]).to have_key(:id)
        expect(merchant[1][0][:id].to_i).to be_an(Integer)

        expect(merchant[1][0][:attributes]).to have_key(:name)
        expect(merchant[1][0][:attributes][:name]).to be_a(String)
      end
    end
  end

  describe "GET /api/v1/merchants/:id" do
    it "returns a single merchant" do
      merchant = create(:merchant)

      get "/api/v1/merchants/#{merchant.id}"

      expect(response).to be_successful

      merchant_response = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_response[:data]).to have_key(:id)
      expect(merchant_response[:data][:id].to_i).to be_an(Integer)

      expect(merchant_response[:data][:attributes]).to have_key(:name)
      expect(merchant_response[:data][:attributes][:name]).to be_a(String)
    end
  end

  describe "GET /api/v1/merchants/:id/items" do
    it "returns all items for a merchant" do
      merchant = create(:merchant)
      items = create_list(:item, 3, merchant_id: merchant.id)

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful

      merchant_items = JSON.parse(response.body, symbolize_names: true)

      merchant_items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id].to_i).to be_an(Integer)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end
  end
end