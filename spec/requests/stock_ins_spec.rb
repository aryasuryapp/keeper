require 'rails_helper'

RSpec.describe "StockIns", type: :request do
  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe "POST /stock_ins" do
    it 'save item to warehouse' do
      post '/stock_ins', params: { item: { sku: "SKU-001" }, category: { name: "Electronics" } }

      expect(JSON.parse(response.body)).to eq(true)
      expect(response).to have_http_status(:created)
      expect(Item.count).to eq(1)
    end

    it 'should not create new category if exist' do
      FactoryBot.create(:category, name: "Electronics")

      post '/stock_ins', params: { item: { sku: "SKU-001" }, category: { name: "Electronics" } }
      expect(response).to have_http_status(:created)
      expect(Category.count).to eq(1)
    end

    it 'should not create bin if some bin empty' do
      FactoryBot.create(:bin, bin_number: 1, filled: false)

      post '/stock_ins', params: { item: { sku: "SKU-001" }, category: { name: "Electronics" } }
      expect(response).to have_http_status(:created)
      expect(Bin.count).to eq(1)
    end

    # TODO: should use nearest bin

    # TODO: should not create item if exist
  end
end
