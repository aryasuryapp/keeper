class StockInsController < ApplicationController
  def create
    item = ::StockInService.new(item_params).call

    render json: item, status: :created

  rescue => e
    render json: e, status: :unprocessable_entity
  end

  private

  def item_params
    params.require(:item).permit(:sku)
  end
end
