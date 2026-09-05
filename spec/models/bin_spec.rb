require 'rails_helper'

RSpec.describe Bin, type: :model do
  let(:warehouse) { FactoryBot.create(:warehouse) }

  describe "when destroy bin" do
    it 'should destroy item' do
      bin = FactoryBot.create(:bin, warehouse_id: warehouse.id, filled: true)
      category = FactoryBot.create(:category, name: "Electronics")
      FactoryBot.create(:item, bin_id: bin.id, category_id: category.id)

      expect {
        bin.destroy
      }.to change { Item.count }.from(1).to(0)
    end
  end
end
