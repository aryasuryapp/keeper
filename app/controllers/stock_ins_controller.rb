class StockInsController < ApplicationController
  def create
    result = ::StockInService.new(stock_in_params).call

    render json: result[:message], status: result[:status]
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

  def stock_in_params
    {
      "sku": params[:sku],
      "category": params[:category]
    }
  end
end
