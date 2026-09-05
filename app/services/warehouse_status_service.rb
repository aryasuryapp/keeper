class WarehouseStatusService
  def initialize(warehouse_id)
    @warehouse_id = warehouse_id
  end

  def call
    bins = Bin.where(warehouse_id: @warehouse_id, filled: true).order(:bin_number)

    data = []
    bins.map do |bin|
      # TODO: check query
      data << { "bin_number" => bin.bin_number, "sku" => bin.item.sku, "category" => bin.item.category.name }
    end

    data
  end
end
