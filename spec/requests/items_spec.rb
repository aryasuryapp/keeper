require 'rails_helper'

RSpec.describe "Items", type: :request do
  let(:warehouse) { FactoryBot.create(:warehouse, total_bins: 4) }

  describe "GET /index" do
    it 'returns items of category X' do
      FactoryBot.create(:bin, bin_number: 1, warehouse_id: warehouse.id, filled: true)
      FactoryBot.create(:bin, bin_number: 3, warehouse_id: warehouse.id, filled: true)

      FactoryBot.create(:category, name: "Electronics", id: 1)
      FactoryBot.create(:item, sku: "SKU-1234", bin_id: 1, category_id: 1)
      FactoryBot.create(:item, sku: "SKU-9999", bin_id: 3, category_id: 1)
      FactoryBot.create(:item, sku: "SKU-0001", bin_id: nil, category_id: 1)

      get '/api/v1/items?category=Electronics'

      expect(JSON.parse(response.body)).to eq([ "SKU-1234", "SKU-9999" ])
      expect(response).to have_http_status(200)
    end

    describe "when no items in category X" do
      it 'return message no items' do
        get '/api/v1/items?category=Electronics'

        expect(JSON.parse(response.body)["message"]).to eq("No items in this category")
        expect(response).to have_http_status(200)
      end
    end
  end
end
