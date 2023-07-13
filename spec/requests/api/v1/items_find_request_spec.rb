require "rails_helper"

RSpec.describe "Items API" do
  describe "GET /api/v1/items/find" do
    it "returns a single item that matches a search term" do
      merchant = create(:merchant)
      item_1 = merchant.items.create(name: "Ring", description: "A ring", unit_price: 100)
      item_2 = merchant.items.create(name: "Necklace", description: "A necklace", unit_price: 200)

      get "/api/v1/items/find", params: { name: "Ring" }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      item_response = JSON.parse(response.body, symbolize_names: true)

      expect(item_response[:data]).to have_key(:id)
      expect(item_response[:data][:id].to_i).to eq(item_1.id)
      expect(item_response[:data][:id].to_i).to_not eq(item_2.id)

      expect(item_response[:data][:attributes]).to have_key(:name)
      expect(item_response[:data][:attributes][:name]).to eq(item_1.name)
      expect(item_response[:data][:attributes][:name]).to_not eq(item_2.name)

      expect(item_response[:data][:attributes]).to have_key(:description)
      expect(item_response[:data][:attributes][:description]).to eq(item_1.description)
      expect(item_response[:data][:attributes][:description]).to_not eq(item_2.description)

      expect(item_response[:data][:attributes]).to have_key(:unit_price)
      expect(item_response[:data][:attributes][:unit_price]).to eq(item_1.unit_price)
    end
  end
end