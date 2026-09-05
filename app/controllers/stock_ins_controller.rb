class StockInsController < ApplicationController
  def create
    params = item_params.merge(category_params)
    item = ::StockInService.new(params).call

    render json: item, status: :created

  rescue => e
    render json: {
      errors: e
    }, status: :unprocessable_entity
  end

  def destroy
    bin = Bin.find(params[:id])
    bin.update!(filled: false)

    item = bin.item
    item.update!(bin_id: nil)

    render json: {
      "message": "Bin number #{bin.bin_number} is free"
    },
    status: :ok
  end

  private

  def item_params
    params.require(:item).permit(:sku)
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
