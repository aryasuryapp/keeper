class WarehousesController < ApplicationController
  def show
    render json: Warehouse.all
  end

  def create
    warehouse = Warehouse.new(warehouse_params)

    if warehouse.save
      render json: warehouse, status: :created
    else
      render json: warehouse.errors, status: unprocessable_entity
    end
  end

  private

  def warehouse_params
    params.require(:warehouse).permit(:total_bins)
  end
end
