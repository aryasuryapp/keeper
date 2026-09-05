require 'rails_helper'

RSpec.describe "Warehouses", type: :request do
  describe "GET /api/v1/warehouses" do
    it 'returns all warehouses' do
      FactoryBot.create(:warehouse)

      get '/api/v1/warehouses'

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe "POST /api/v1/warehouses" do
    it "create warehouse" do
      post '/api/v1/warehouses', params: { warehouse: { total_bins: 6 } }

      expect(JSON.parse(response.body)["message"]).to eq("Created a warehouse with 6 bins")
      expect(response).to have_http_status(:created)
      expect(Warehouse.count).to eq(1)
    end
  end

  describe "GET /api/v1/warehouses/status" do
    let(:warehouse) { FactoryBot.create(:warehouse, total_bins: 4) }

    it 'get all bins' do
      FactoryBot.create(:bin, bin_number: 1, warehouse_id: warehouse.id, filled: true, id: 1)
      FactoryBot.create(:bin, bin_number: 2, warehouse_id: warehouse.id)
      FactoryBot.create(:bin, bin_number: 3, warehouse_id: warehouse.id, filled: true, id: 3)

      FactoryBot.create(:category, name: "Electronics", id: 1)
      FactoryBot.create(:category, name: "Apparel", id: 2)

      FactoryBot.create(:item, sku: "SKU-001", bin_id: 1, category_id: 1)
      FactoryBot.create(:item, sku: "SKU-102", bin_id: 3, category_id: 2)

      get '/api/v1/warehouses/status'

      expect(JSON.parse(response.body)).to eq(
        [
          { "bin_number" => 1, "sku" => "SKU-001", "category" => "Electronics" },
          { "bin_number" => 3, "sku" => "SKU-102", "category" => "Apparel" }
        ]
      )
      expect(response).to have_http_status(200)
    end
  end
end
