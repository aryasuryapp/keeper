require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe "when create" do
    it 'should have total bins' do
      warehouse = Warehouse.create()
      expect(warehouse.errors.messages).to eq({ total_bins: [ "can't be blank" ] })
    end

    it 'should success' do
      expect {
        Warehouse.create!(total_bins: 10)
      }.to change { Warehouse.count }.from(0).to(1)
    end
  end

  describe "when destroy" do
    it 'should destroy bin' do
      warehouse = Warehouse.create!(total_bins: 10)
      Bin.create!(warehouse: warehouse, filled: false, bin_number: 1)
      Bin.create!(warehouse: warehouse, filled: false, bin_number: 2)

      expect {
        warehouse.destroy
      }.to change { Bin.count }.from(2).to(0)
    end
  end
end
