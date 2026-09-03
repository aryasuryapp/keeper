class StockInService
  def initialize(params)
    @params = params
  end

  def call
    category = Category.find_by(name: @params["name"])
    unless category
      category = Category.create!(name: @params["name"])
    end
    bin = Bin.create!(bin_number: 1)

    item = Item.new(sku: @params["sku"], category_id: category.id, bin_id: bin.id)
    item.save!
  end
end
