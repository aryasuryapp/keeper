class BinsController < ApplicationController
  def index
    category = Category.find_by(name: item_params[:category])
    unless category
      return render json: {
        "message": "No items in this category"
      }
    end

    items = Item.where(category: category.id).where.not(bin_id: nil)
    data = []
    items.map do |item|
      # TODO: check query
      bin = Bin.find(item.bin_id)
      data << bin.bin_number
    end

    render json: data, status: :ok
  end

  private

  def item_params
    params.permit(:category)
  end
end
