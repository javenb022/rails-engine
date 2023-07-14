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

      expect(item_response[:data][0]).to have_key(:id)
      expect(item_response[:data][0][:id].to_i).to eq(item_1.id)
      expect(item_response[:data][0][:id].to_i).to_not eq(item_2.id)

      expect(item_response[:data][0][:attributes]).to have_key(:name)
      expect(item_response[:data][0][:attributes][:name]).to eq(item_1.name)
      expect(item_response[:data][0][:attributes][:name]).to_not eq(item_2.name)

      expect(item_response[:data][0][:attributes]).to have_key(:description)
      expect(item_response[:data][0][:attributes][:description]).to eq(item_1.description)
      expect(item_response[:data][0][:attributes][:description]).to_not eq(item_2.description)

      expect(item_response[:data][0][:attributes]).to have_key(:unit_price)
      expect(item_response[:data][0][:attributes][:unit_price]).to eq(item_1.unit_price)
    end

    it "returns a single item that matches a min_price search term" do
      merchant = create(:merchant)
      item_1 = create(:item, unit_price: 100, merchant_id: merchant.id)
      item_2 = create(:item, unit_price: 200, merchant_id: merchant.id)
      item_3 = create(:item, unit_price: 300, merchant_id: merchant.id)
      item_4 = create(:item, unit_price: 400, merchant_id: merchant.id)

      get "/api/v1/items/find", params: { min_price: 200 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(3)
      expect(json[:data][0][:attributes][:name]).to eq(item_2.name)
      expect(json[:data][1][:attributes][:name]).to eq(item_3.name)
      expect(json[:data][2][:attributes][:name]).to eq(item_4.name)
    end

    it "returns a single item that matches a max_price search term" do
      merchant = create(:merchant)
      item_1 = create(:item, unit_price: 100, merchant_id: merchant.id)
      item_2 = create(:item, unit_price: 200, merchant_id: merchant.id)
      item_3 = create(:item, unit_price: 300, merchant_id: merchant.id)
      item_4 = create(:item, unit_price: 400, merchant_id: merchant.id)

      get "/api/v1/items/find", params: { max_price: 200 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(2)
      expect(json[:data][0][:attributes][:name]).to eq(item_1.name)
      expect(json[:data][1][:attributes][:name]).to eq(item_2.name)
    end
  end
end
