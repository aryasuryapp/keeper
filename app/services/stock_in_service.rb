class StockInService
  def initialize(params)
    @params = params
  end

  def call
    warehouse = Warehouse.first
    unless warehouse
      raise "No warehouse found"
    end

    category = Category.find_by(name: @params["name"])
    unless category
      category = Category.create!(name: @params["name"])
    end

    bin = Bin.where(filled: false).order(:bin_number).first
    unless bin
      # TODO: add validation max bin in warehouse
      bin = Bin.create!(filled: true)
    end

    # TODO: add unique index in DB
    item = Item.find_by(sku: @params["sku"])
    if item.nil?
      item = Item.new(sku: @params["sku"], category_id: category.id, bin_id: bin.id)
    elsif item.bin_id
      return item
    else
      item.bin_id = bin.id
    end

    item.save!

    item
  end
end
