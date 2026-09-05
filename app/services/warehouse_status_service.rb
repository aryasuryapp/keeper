class WarehouseStatusService
  def initialize(warehouse_id)
    @warehouse_id = warehouse_id
  end

  def call
    bins = Bin.where(warehouse_id: @warehouse_id, filled: true).order(:bin_number)

    data = []

    items = Item.where(bin_id: bins.pluck(:id))
    categories = Category.where(id: items.pluck(:category_id))
    bins.map do |bin|
      item = items.find { |item| item.bin_id == bin.id }
      category_name = categories.find { |category| category.id == item.category_id }.name
      data << { "bin_number" => bin.bin_number, "sku" => item.sku, "category" => category_name }
    end

    data
  end
end
