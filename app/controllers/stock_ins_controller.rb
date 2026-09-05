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

  private

  def item_params
    params.require(:item).permit(:sku)
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
