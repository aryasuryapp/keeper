class StockInService
  def initialize(params)
    @params = params
  end

  def call
    # Given only have 1 warehouse
    warehouse = Warehouse.first
    unless warehouse
      raise "No warehouse found"
    end

    item = Item.find_by(sku: @params[:sku])
    if item.present? && item.bin_id
      bin = Bin.find(item.bin_id)
      return { message: message(bin), status: :ok }
    end

    category = Category.find_by(name: @params[:category])
    unless category
      category = Category.create!(name: @params[:category])
    end

    bin = use_nearest_bin(warehouse)
    raise "Warehouse is full" unless bin
    bin.update!(filled: true)

    if item.nil?
      Item.create!(sku: @params[:sku], category_id: category.id, bin_id: bin.id)
    else
      item.update!(bin_id: bin.id)
    end

    { message: message(bin), status: :created }
  end

  private

  def message(bin)
    {
      "bin_number": bin.bin_number,
      "message": "Allocated bin number: #{bin.bin_number}"
    }
  end

  def use_nearest_bin(warehouse)
    empty_bin = nil
    bins = Bin.where(warehouse_id: warehouse.id).order(:bin_number)

    for i in 0..warehouse.total_bins-1
      if bins[i].nil?
        empty_bin = Bin.create!(warehouse: warehouse, bin_number: i + 1)
        break
      elsif bins[i].bin_number == i + 1 && bins[i].filled == true
      elsif bins[i].bin_number == i + 1
        empty_bin = bins[i]
        break
      else
        empty_bin = Bin.create!(warehouse: warehouse, bin_number: i + 1)
        break
      end
    end
    empty_bin
  end
end
