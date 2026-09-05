require 'rails_helper'

RSpec.describe "Bins", type: :request do
  let(:warehouse) { FactoryBot.create(:warehouse, total_bins: 6) }

  describe "GET /index" do
    it 'return items all category' do
      FactoryBot.create(:bin, bin_number: 1, warehouse_id: warehouse.id, filled: true, id: 1)
      FactoryBot.create(:bin, bin_number: 2, warehouse_id: warehouse.id, filled: true, id: 2)
      FactoryBot.create(:bin, bin_number: 3, warehouse_id: warehouse.id, filled: false, id: 3)
      FactoryBot.create(:bin, bin_number: 4, warehouse_id: warehouse.id, filled: true, id: 4)

      FactoryBot.create(:category, name: "Electronics", id: 1)
      FactoryBot.create(:item, sku: "SKU-1234", bin_id: 1, category_id: 1)
      FactoryBot.create(:item, sku: "SKU-9999", bin_id: 2, category_id: 1)
      FactoryBot.create(:item, sku: "SKU-0001", bin_id: 4, category_id: 1)

      get '/bins'

      expect(JSON.parse(response.body)).to eq({ "data"=>[ 1, 2, 4 ], "message"=>"Success get bin numbers" })
      expect(response).to have_http_status(200)
    end

    it 'returns items of category X' do
      FactoryBot.create(:bin, bin_number: 1, warehouse_id: warehouse.id, filled: true, id: 1)
      FactoryBot.create(:bin, bin_number: 2, warehouse_id: warehouse.id, filled: true, id: 2)
      FactoryBot.create(:bin, bin_number: 3, warehouse_id: warehouse.id, filled: false, id: 3)
      FactoryBot.create(:bin, bin_number: 4, warehouse_id: warehouse.id, filled: true, id: 4)

      FactoryBot.create(:category, name: "Electronics", id: 1)
      FactoryBot.create(:category, name: "Apparel", id: 2)
      FactoryBot.create(:item, sku: "SKU-1234", bin_id: 1, category_id: 1)
      FactoryBot.create(:item, sku: "SKU-9999", bin_id: 2, category_id: 1)
      FactoryBot.create(:item, sku: "SKU-0001", bin_id: 4, category_id: 2)

      get '/bins?category=Electronics'

      expect(JSON.parse(response.body)).to eq({ "data"=>[ 1, 2 ], "message"=>"Success get bin numbers" })
      expect(response).to have_http_status(200)
    end

    describe "when no items in category X" do
      it 'return message no items' do
        get '/bins?category=Electronics'

        expect(JSON.parse(response.body)["message"]).to eq("No items in this category")
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET /bins/:sku" do
    it 'return bin number' do
      FactoryBot.create(:bin, bin_number: 6, warehouse_id: warehouse.id, filled: true, id: 1)
      FactoryBot.create(:category, name: "Electronics", id: 1)
      FactoryBot.create(:item, sku: "SKU-3141", bin_id: 1, category_id: 1)

      get '/bins/SKU-3141'

      expect(JSON.parse(response.body)).to eq(6)
      expect(response).to have_http_status(200)
    end

    it 'return not found' do
      get '/bins/SKU-3141'

      expect(JSON.parse(response.body)["message"]).to eq("SKU not found")
      expect(response).to have_http_status(404)
    end
  end
end
