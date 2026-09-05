require 'rails_helper'

RSpec.describe "StockIns", type: :request do
  let!(:warehouse) { FactoryBot.create(:warehouse, total_bins: 10) }

  describe "POST /api/v1/stock_ins" do
    it 'should validate warehouse' do
      Warehouse.delete_all

      post '/api/v1/stock_ins', params: { sku: "SKU-001", category: "Electronics" }

      expect(JSON.parse(response.body)["errors"]).to eq("No warehouse found")
    end

    it 'save item to warehouse' do
      post '/api/v1/stock_ins', params: { sku: "SKU-001", category: "Electronics" }

      expect(JSON.parse(response.body)["errors"]).to be_nil
      expect(response).to have_http_status(:created)
      expect(Item.count).to eq(1)
    end

    it 'should not create new category if exist' do
      FactoryBot.create(:category, name: "Electronics")

      post '/api/v1/stock_ins', params: { sku: "SKU-001", category: "Electronics" }

      expect(JSON.parse(response.body)["errors"]).to be_nil
      expect(response).to have_http_status(:created)
      expect(Category.count).to eq(1)
    end

    it 'should not create item if exist' do
      FactoryBot.create(:category, name: "Electronics", id: 1)
      FactoryBot.create(:item, sku: "SKU-001", id: 1, category_id: 1)

      post '/api/v1/stock_ins', params: { sku: "SKU-001", category: "Electronics" }

      expect(JSON.parse(response.body)["errors"]).to be_nil
      expect(response).to have_http_status(:created)
      expect(Item.count).to eq(1)
      expect(Item.first.bin_id).not_to be_nil
    end

    describe 'validate bin' do
      it 'should not create bin if some bin empty' do
        FactoryBot.create(:bin, bin_number: 1, filled: false, warehouse_id: warehouse.id)

        post '/api/v1/stock_ins', params: { sku: "SKU-001", category: "Electronics" }

        expect(JSON.parse(response.body)["errors"]).to be_nil
        expect(response).to have_http_status(:created)
        expect(Bin.count).to eq(1)
        expect(Bin.first.filled).to eq(true)
      end

      it 'should use nearest bin' do
        FactoryBot.create(:bin, bin_number: 2, filled: false, id: 1, warehouse_id: warehouse.id)
        FactoryBot.create(:bin, bin_number: 1, filled: false, id: 2, warehouse_id: warehouse.id)

        post '/api/v1/stock_ins', params: { sku: "SKU-001", category: "Electronics" }

        expect(JSON.parse(response.body)["errors"]).to be_nil
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq(
          {
            "bin_number" => 1,
            "message" => "Allocated bin number: 1"
          }
        )
      end

      it 'should create nearest bin' do
        FactoryBot.create(:bin, bin_number: 1, filled: true, warehouse_id: warehouse.id)
        FactoryBot.create(:bin, bin_number: 3, filled: false, warehouse_id: warehouse.id)

        post '/api/v1/stock_ins', params: { sku: "SKU-001", category: "Electronics" }

        expect(JSON.parse(response.body)["errors"]).to be_nil
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq(
          {
            "bin_number" => 2,
            "message" => "Allocated bin number: 2"
          }
        )
      end

      it 'should create nearest bin' do
        FactoryBot.create(:bin, bin_number: 1, filled: true, warehouse_id: warehouse.id)
        FactoryBot.create(:bin, bin_number: 4, filled: false, warehouse_id: warehouse.id)

        post '/api/v1/stock_ins', params: { sku: "SKU-001", category: "Electronics" }

        expect(JSON.parse(response.body)["errors"]).to be_nil
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq(
          {
            "bin_number" => 2,
            "message" => "Allocated bin number: 2"
          }
        )
      end

      it 'should create new bin' do
        FactoryBot.create(:bin, bin_number: 1, filled: true, warehouse_id: warehouse.id)
        FactoryBot.create(:bin, bin_number: 2, filled: true, warehouse_id: warehouse.id)

        post '/api/v1/stock_ins', params: { sku: "SKU-001", category: "Electronics" }

        expect(JSON.parse(response.body)["errors"]).to be_nil
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq(
          {
            "bin_number" => 3,
            "message" => "Allocated bin number: 3"
          }
        )
      end

      it 'should validate max bin' do
        warehouse = Warehouse.first
        warehouse.update!(total_bins: 3)

        FactoryBot.create(:bin, bin_number: 1, filled: true, warehouse_id: warehouse.id)
        FactoryBot.create(:bin, bin_number: 2, filled: true, warehouse_id: warehouse.id)
        FactoryBot.create(:bin, bin_number: 3, filled: true, warehouse_id: warehouse.id)

        post '/api/v1/stock_ins', params: { sku: "SKU-001", category: "Electronics" }

        expect(JSON.parse(response.body)["errors"]).to eq("Warehouse is full")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'multiple request same sku' do
      before do
        post '/api/v1/stock_ins', params: { sku: "SKU-001", category: "Electronics" }

        expect(JSON.parse(response.body)).to eq(
          { "bin_number" => 1, "message" => "Allocated bin number: 1" }
        )
        expect(response).to have_http_status(201)
      end

      # make sku as idempotency key
      it 'return detail item and bin' do
        post '/api/v1/stock_ins', params: { sku: "SKU-001", category: "Electronics" }

        expect(JSON.parse(response.body)).to eq(
          { "bin_number" => 1, "message" => "Allocated bin number: 1" }
        )
        expect(response).to have_http_status(200)
      end

      it 'should only create 1 item' do
        post '/api/v1/stock_ins', params: { sku: "SKU-001", category: "Electronics" }

        expect(Item.count).to eq(1)
      end

      it 'should create 1 bin' do
        post '/api/v1/stock_ins', params: { sku: "SKU-001", category: "Electronics" }

        expect(Bin.count).to eq(1)
      end
    end
  end

  describe "DELETE /api/v1/stock_ins" do
    describe "when bin not found" do
      it 'return 404' do
        delete "/api/v1/stock_ins/1"

        expect(JSON.parse(response.body)).to be_nil
        expect(response).to have_http_status(404)
      end
    end

    describe "when bin found" do
      it 'should free bin and delete bin_id on item' do
        bin = FactoryBot.create(:bin, id: 1, filled: true, warehouse_id: warehouse.id, bin_number: 1)
        category_electronic = FactoryBot.create(:category, name: "Electronics", id: 1)
        item = FactoryBot.create(:item, bin_id: bin.id, sku: "SKU-001", category_id: category_electronic.id)

        delete "/api/v1/stock_ins/1"

        # TODO: use spec helper for jsonparse
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq(
          { "message" => "Bin number #{bin.bin_number} is free" }
        )

        bin.reload
        item.reload
        expect(bin.filled).to be false
        expect(item.bin_id).to be_nil
      end

      describe "when already empty" do
        it 'should return empty bin' do
          FactoryBot.create(:bin, id: 1, filled: false, warehouse_id: warehouse.id, bin_number: 4)

          delete "/api/v1/stock_ins/4"

          expect(JSON.parse(response.body)["message"]).to eq("Empty bin")
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end
