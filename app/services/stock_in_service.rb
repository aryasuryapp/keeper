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

    bin = Bin.where(filled: false, warehouse_id: warehouse.id).order(:bin_number).first
    # TODO: bin should be filled
    unless bin
      last_bin = Bin.where(warehouse_id: warehouse.id).order(:bin_number).last
      if last_bin
        bin = Bin.create!(filled: true, warehouse_id: warehouse.id, bin_number: (last_bin.bin_number + 1))
      else
        bin = Bin.create!(filled: true, warehouse_id: warehouse.id, bin_number: 1)
      end
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

    {
      "bin_number": bin.bin_number,
      "message": "Allocated bin number: #{bin.bin_number}"
    }
  end
end
