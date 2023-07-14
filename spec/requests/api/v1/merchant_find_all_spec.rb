require "rails_helper"

RSpec.describe "Merchants API" do
  describe "GET /api/v1/merchants/find_all" do
    it "returns the first merchant that match a name search term" do
      merchant_1 = create(:merchant, name: "Ring World")
      merchant_2 = create(:merchant, name: "Turing School")

      get "/api/v1/merchants/find_all", params: { name: "ring" }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json.count).to eq(1)
      expect(json[:data][:attributes][:name]).to eq(merchant_1.name)
    end

    it "returns an empty array if no merchants match the search term" do
      get "/api/v1/merchants/find_all", params: { name: "ring" }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data]).to eq({})
    end
  end
end