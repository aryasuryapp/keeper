require 'rails_helper'

RSpec.describe Bin, type: :model do
  let(:warehouse) { FactoryBot.create(:warehouse) }

  describe "when destroy" do
    it 'should destroy item' do
      bin = FactoryBot.create(:bin, warehouse_id: warehouse.id, filled: true)
      category = FactoryBot.create(:category, name: "Electronics")
      FactoryBot.create(:item, bin_id: bin.id, category_id: category.id)

      expect {
        bin.destroy
      }.to change { Item.count }.from(1).to(0)
    end
  end

  describe "when create" do
    it 'should be unique bin_number inside 1 warehouse' do
      Bin.create!(warehouse: warehouse, bin_number: 1)
      bin = Bin.create(warehouse: warehouse, bin_number: 1)
      expect(bin.errors.messages).to eq({ bin_number: [ "has already been taken" ] })
    end

    it 'could be same bin_number inside 2 warehouse' do
      warehouse2 = Warehouse.create!(total_bins: 10)

      Bin.create!(warehouse: warehouse, bin_number: 1)
      bin = Bin.create(warehouse: warehouse2, bin_number: 1)
      expect(bin.errors.messages).to eq({})
    end
  end
end
