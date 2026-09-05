require 'rails_helper'

RSpec.describe "Warehouses", type: :request do
  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe "GET /warehouses" do
    it 'returns all warehouses' do
      Warehouse.delete_all
      FactoryBot.create(:warehouse)

      get '/warehouses'

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe "POST /warehouses" do
    it "create warehouse" do
      Warehouse.delete_all
      post '/warehouses', params: { warehouse: { total_bins: 8 } }

      expect(response).to have_http_status(:created)
      expect(Warehouse.count).to eq(1)
    end
  end
end
