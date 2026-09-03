require 'rails_helper'

RSpec.describe "StockIns", type: :request do
  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe "POST /stock_ins" do
    it 'save item to warehouse' do
      post '/stock_ins', params: { item: { sku: "SKU-001" } }

      expect(response).to have_http_status(:created)
      expect(Item.count).to eq(1)
    end

    # TODO: should not create new category is exist
    # TODO: should not create bin if some bin empty
    # TODO: should not create item if exist
  end
end
