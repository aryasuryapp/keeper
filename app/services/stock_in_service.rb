class StockInService
  def initialize(params)
    @params = params
  end

  def call
    category = Category.find_by(name: @params["name"])
    unless category
      category = Category.create!(name: @params["name"])
    end

    bin = Bin.where(filled: false).order(:bin_number).first
    unless bin
      # TODO: add validation max bin in warehouse
      bin = Bin.create!(filled: true)
    end

    item = Item.new(sku: @params["sku"], category_id: category.id, bin_id: bin.id)
    item.save!
  end
end
