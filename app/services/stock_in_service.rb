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

    # TODO: add unique index in DB
    item = Item.find_by(sku: @params[:sku])
    if item.present? && item.bin_id
      bin = Bin.find(item.bin_id)
      return { message: message(bin), status: :ok }
    end

    category = Category.find_by(name: @params[:category])
    unless category
      category = Category.create!(name: @params[:category])
    end

    bin = Bin.where(filled: false, warehouse_id: warehouse.id).order(:bin_number).first
    if bin
      bin.update!(filled: true)
    else
      last_bin = Bin.where(warehouse_id: warehouse.id).order(:bin_number).last
      if last_bin
        bin = Bin.create!(filled: true, warehouse_id: warehouse.id, bin_number: (last_bin.bin_number + 1))
      else
        bin = Bin.create!(filled: true, warehouse_id: warehouse.id, bin_number: 1)
      end
    end

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
end
