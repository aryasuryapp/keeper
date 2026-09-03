class StockInService
  def initialize(item)
    @item = item
  end

  def call
    category = Category.create!(name: "Electronic")
    bin = Bin.create!(bin_number: 1)

    item = Item.new(sku: @item["sku"], category_id: category.id, bin_id: bin.id)
    item.save!
  end
end
