require 'rails_helper'

RSpec.describe "StockIns", type: :request do
  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe "POST /stock_ins" do
    let!(:warehouse) { FactoryBot.create(:warehouse, total_bins: 10) }

    it 'should validate warehouse' do
      Warehouse.delete_all

      post '/stock_ins', params: { item: { sku: "SKU-001" }, category: { name: "Electronics" } }

      expect(JSON.parse(response.body)["errors"]).to eq("No warehouse found")
    end

    it 'save item to warehouse' do
      post '/stock_ins', params: { item: { sku: "SKU-001" }, category: { name: "Electronics" } }

      expect(JSON.parse(response.body)["errors"]).to be_nil
      expect(response).to have_http_status(:created)
      expect(Item.count).to eq(1)
    end

    describe 'validate bin' do
      it 'should not create bin if some bin empty' do
        FactoryBot.create(:bin, bin_number: 1, filled: false, warehouse_id: warehouse.id)

        post '/stock_ins', params: { item: { sku: "SKU-001" }, category: { name: "Electronics" } }

        expect(JSON.parse(response.body)["errors"]).to be_nil
        expect(response).to have_http_status(:created)
        expect(Bin.count).to eq(1)
        expect(Bin.first.filled).to eq(true)
      end

      it 'should use nearest bin' do
        FactoryBot.create(:bin, bin_number: 2, filled: false, id: 1, warehouse_id: warehouse.id)
        FactoryBot.create(:bin, bin_number: 1, filled: false, id: 2, warehouse_id: warehouse.id)

        # TODO: body should be
        # { "sku": "SKU-1234", "category": "Electronics" }
        post '/stock_ins', params: { item: { sku: "SKU-001" }, category: { name: "Electronics" } }

        expect(JSON.parse(response.body)["errors"]).to be_nil
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq(
          {
            "bin_number" => 1,
            "message" => "Allocated bin number: 1"
          }
        )
      end

      it 'should validate max bin' do
        warehouse = Warehouse.first
        warehouse.update!(total_bins: 3)

        FactoryBot.create(:bin, bin_number: 1, filled: true, warehouse_id: warehouse.id)
        FactoryBot.create(:bin, bin_number: 2, filled: true, warehouse_id: warehouse.id)
        FactoryBot.create(:bin, bin_number: 3, filled: true, warehouse_id: warehouse.id)

        post '/stock_ins', params: { item: { sku: "SKU-001" }, category: { name: "Electronics" } }

        expect(JSON.parse(response.body)["errors"]).to eq("Warehouse is full")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    it 'should not create new category if exist' do
      FactoryBot.create(:category, name: "Electronics")

      post '/stock_ins', params: { item: { sku: "SKU-001" }, category: { name: "Electronics" } }

      expect(JSON.parse(response.body)["errors"]).to be_nil
      expect(response).to have_http_status(:created)
      expect(Category.count).to eq(1)
    end

    it 'should not create item if exist' do
      FactoryBot.create(:item, sku: "SKU-001", id: 1)

      post '/stock_ins', params: { item: { sku: "SKU-001" }, category: { name: "Electronics" } }

      expect(JSON.parse(response.body)["errors"]).to be_nil
      expect(response).to have_http_status(:created)
      expect(Item.count).to eq(1)
      expect(Item.first.bin_id).not_to be_nil
    end
  end
end
