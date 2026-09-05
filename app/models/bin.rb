class Bin < ApplicationRecord
  validates :warehouse_id, presence: true
  validates :bin_number, presence: true

  before_save :validate_max_bins

  has_one :item

  private

  def validate_max_bins
    max_bins = Warehouse.find(self.warehouse_id).total_bins

    if self.bin_number > max_bins
      raise "Warehouse is full"
    end
  end
end
