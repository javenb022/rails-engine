require "rails_helper"

RSpec.describe "Items API" do
  describe "GET /api/v1/items" do
    it "returns all items" do
      merchant = create(:merchant)
      items = create_list(:item, 3, merchant_id: merchant.id)

      get "/api/v1/items"

      expect(response).to be_successful

      items_response = JSON.parse(response.body, symbolize_names: true)

      items_response[:data].each do |item|
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

  describe "GET /api/v1/items/:id" do
    it "returns a single item" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      item2 = create(:item, merchant_id: merchant.id)

      get "/api/v1/items/#{item.id}"

      expect(response).to be_successful

      item_response = JSON.parse(response.body, symbolize_names: true)

      expect(item_response[:data]).to have_key(:id)
      expect(item_response[:data][:id].to_i).to be_an(Integer)

      expect(item_response[:data][:attributes]).to have_key(:name)
      expect(item_response[:data][:attributes][:name]).to be_a(String)

      expect(item_response[:data][:attributes]).to have_key(:description)
      expect(item_response[:data][:attributes][:description]).to be_a(String)

      expect(item_response[:data][:attributes]).to have_key(:unit_price)
      expect(item_response[:data][:attributes][:unit_price]).to be_a(Float)

      expect(item_response[:data][:attributes]).to have_key(:merchant_id)
      expect(item_response[:data][:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  describe "POST /api/v1/items" do
    it "creates an item" do
      
    end
  end
end