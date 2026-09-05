require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:warehouse) { FactoryBot.create(:warehouse) }

  describe "when destroy item" do
    it 'should empty bin' do
      bin = FactoryBot.create(:bin, warehouse_id: warehouse.id, filled: true)
      category = FactoryBot.create(:category, name: "Electronics")
      item = FactoryBot.create(:item, bin_id: bin.id, category_id: category.id)

      expect {
        item.destroy
      }.to change { Bin.first.filled }.from(true).to(false)
    end
  end
end
