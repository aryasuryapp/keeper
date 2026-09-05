class BinsService
  def initialize(params)
    @params = params
  end

  def call
    if @params[:category].present?
      category = Category.find_by(name: @params[:category])
      unless category
        return message([], "No items in this category", :ok)
      end

      items = Item.where(category: category.id).where.not(bin_id: nil)
    else
      items = Item.where.not(bin_id: nil)
    end

    data = Bin.where(id: items.pluck(:bin_id)).pluck(:bin_number)

    message(data, "Success get bin numbers", :ok)
  end

  private

  def message(data, message, status)
    {
      "data": data,
      "message": message,
      "status": status
    }
  end
end
