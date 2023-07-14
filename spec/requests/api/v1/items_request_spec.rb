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

    it "returns an empty array if there are no items" do
      get "/api/v1/items"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data]).to eq([])
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

    it "returns an error if the item id is invalid" do
      get "/api/v1/items/99999999"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:errors][0][:status]).to eq("404")
      expect(json[:errors][0][:title]).to eq("Couldn't find Item with 'id'=99999999")
    end
  end

  describe "POST /api/v1/items" do
    it "creates an item" do
      merchant = create(:merchant)

      post "/api/v1/items", params: {
        name: "Soap",
        description: "Cleans your body well",
        unit_price: 10.99,
        merchant_id: merchant.id.to_s
      }

      expect(response).to be_successful
      expect(response.status).to eq(201)

      item_response = JSON.parse(response.body, symbolize_names: true)

      expect(item_response[:data]).to have_key(:id)
      expect(item_response[:data][:id].to_i).to be_an(Integer)

      expect(item_response[:data][:attributes]).to have_key(:name)
      expect(item_response[:data][:attributes][:name]).to be_a(String)
      expect(item_response[:data][:attributes][:name]).to eq("Soap")

      expect(item_response[:data][:attributes]).to have_key(:description)
      expect(item_response[:data][:attributes][:description]).to be_a(String)
      expect(item_response[:data][:attributes][:description]).to eq("Cleans your body well")

      expect(item_response[:data][:attributes]).to have_key(:unit_price)
      expect(item_response[:data][:attributes][:unit_price]).to be_a(Float)
      expect(item_response[:data][:attributes][:unit_price]).to eq(10.99)

      expect(item_response[:data][:attributes]).to have_key(:merchant_id)
      expect(item_response[:data][:attributes][:merchant_id]).to be_an(Integer)
    end

    it "returns an error if any attributes are missing" do
      merchant = create(:merchant)

      post "/api/v1/items", params: {
        # name: "Soap",
        # description: "Cleans your body well",
        unit_price: 10.99,
        merchant_id: merchant.id.to_s
      }

      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:error]).to eq("Name can't be blank and Description can't be blank")
    end

    it "ignores any attributes that are not allowed" do
      merchant = create(:merchant)

      post "/api/v1/items", params: {
        name: "Soap",
        description: "Cleans your body well",
        unit_price: 10.99,
        merchant_id: merchant.id.to_s,
        color: "blue"
      }

      expect(response).to be_successful
      expect(response.status).to eq(201)

      item_response = JSON.parse(response.body, symbolize_names: true)

      expect(item_response[:data]).to have_key(:id)
      expect(item_response[:data][:id].to_i).to be_an(Integer)

      expect(item_response[:data][:attributes]).to have_key(:name)
      expect(item_response[:data][:attributes][:name]).to be_a(String)
      expect(item_response[:data][:attributes][:name]).to eq("Soap")

      expect(item_response[:data][:attributes]).to have_key(:description)
      expect(item_response[:data][:attributes][:description]).to be_a(String)
      expect(item_response[:data][:attributes][:description]).to eq("Cleans your body well")

      expect(item_response[:data][:attributes]).to have_key(:unit_price)
      expect(item_response[:data][:attributes][:unit_price]).to be_a(Float)
      expect(item_response[:data][:attributes][:unit_price]).to eq(10.99)

      expect(item_response[:data][:attributes]).to have_key(:merchant_id)
      expect(item_response[:data][:attributes][:merchant_id]).to be_an(Integer)

      expect(item_response[:data][:attributes]).to_not have_key(:color)
    end
  end

  describe "PATCH /api/v1/items/:id" do
    it "updates an item" do
      merchant = create(:merchant)
      item = merchant.items.create(name: "Soap", description: "Cleans your body well", unit_price: 10.99)

      patch "/api/v1/items/#{item.id}", params: {
        description: "Cleans your body well and smells good"
      }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data]).to have_key(:id)
      expect(json[:data][:id].to_i).to be_an(Integer)

      expect(json[:data][:attributes]).to have_key(:name)
      expect(json[:data][:attributes][:name]).to be_a(String)
      expect(json[:data][:attributes][:name]).to eq("Soap")

      expect(json[:data][:attributes]).to have_key(:description)
      expect(json[:data][:attributes][:description]).to be_a(String)
      expect(json[:data][:attributes][:description]).to eq("Cleans your body well and smells good")
      expect(json[:data][:attributes][:description]).to_not eq("Cleans your body well")

      expect(json[:data][:attributes]).to have_key(:unit_price)
      expect(json[:data][:attributes][:unit_price]).to be_a(Float)
      expect(json[:data][:attributes][:unit_price]).to eq(10.99)

      expect(json[:data][:attributes]).to have_key(:merchant_id)
      expect(json[:data][:attributes][:merchant_id]).to be_an(Integer)
    end

    it "returns an error if an item can't be found" do
      patch "/api/v1/items/10", params: { name: "Soap" }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:errors][0][:status]).to eq("404")
      expect(json[:errors][0][:title]).to eq("Couldn't find Item with 'id'=10")
    end

    it "returns an error if the merchant id is invalid" do
      merchant = create(:merchant)
      item = merchant.items.create(name: "Soap", description: "Cleans your body well", unit_price: 10.99)

      patch "/api/v1/items/#{item.id}", params: {
        merchant_id: 99_999_999
      }

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:error]).to eq("Merchant must exist")

      expect(item.merchant_id).to eq(merchant.id)
      expect(item.merchant_id).to_not eq(99_999_999)
    end
  end

  describe "DELETE /api/v1/items/:id" do
    it "deletes an item" do
      merchant = create(:merchant)
      customer = create(:customer)
      item = merchant.items.create(name: "Soap", description: "Cleans your hands well", unit_price: 10.99)
      item2 = merchant.items.create(name: "Body Wash", description: "Cleans your body well", unit_price: 12.99)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)

      expect(merchant.items.count).to eq(1)
      expect(merchant.items).to_not include(item)
    end

    it "deletes the invoice if it is the only item on the invoice" do
      merchant = create(:merchant)
      customer = create(:customer)
      item = merchant.items.create(name: "Soap", description: "Cleans your hands well", unit_price: 10.99)
      invoice = Invoice.create(customer_id: customer.id, merchant_id: merchant.id, status: "shipped")
      invoice_item = InvoiceItem.create(item_id: item.id, invoice_id: invoice.id, quantity: 1, unit_price: 10.99)

      expect(Invoice.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(Invoice.count).to eq(0)
      expect { Invoice.find(invoice.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "does not delete the invoice if there are other items on the invoice" do
      merchant = create(:merchant)
      customer = create(:customer)
      item = merchant.items.create(name: "Soap", description: "Cleans your hands well", unit_price: 10.99)
      item2 = merchant.items.create(name: "Body Wash", description: "Cleans your body well", unit_price: 12.99)
      invoice = Invoice.create(customer_id: customer.id, merchant_id: merchant.id, status: "shipped")
      invoice_item = InvoiceItem.create(item_id: item.id, invoice_id: invoice.id, quantity: 1, unit_price: 10.99)
      invoice_item2 = InvoiceItem.create(item_id: item2.id, invoice_id: invoice.id, quantity: 1, unit_price: 12.99)

      expect(Invoice.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(Invoice.count).to eq(1)
      expect { Invoice.find(invoice.id) }.to_not raise_error
    end

    it "returns an error if the item can't be found" do
      delete "/api/v1/items/9"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:errors][0][:status]).to eq("404")
      expect(json[:errors][0][:title]).to eq("Couldn't find Item with 'id'=9")
    end
  end

  describe "GET /api/v1/items/:id/merchant" do
    it "returns the merchant for an item" do
      merchant = create(:merchant)
      item = merchant.items.create(name: "Soap", description: "Cleans your hands well", unit_price: 10.99)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data]).to have_key(:id)
      expect(json[:data][:id].to_i).to eq(merchant.id)

      expect(json[:data][:attributes]).to have_key(:name)
      expect(json[:data][:attributes][:name]).to eq(merchant.name)
    end

    it "returns an error if the item can't be found" do
      get "/api/v1/items/10/merchant"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:errors][0][:status]).to eq("404")
      expect(json[:errors][0][:title]).to eq("Couldn't find Item with 'id'=10")
    end
  end
end
