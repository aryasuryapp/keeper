class WarehousesController < ApplicationController
  def index
    render json: Warehouse.all
  end

  def create
    warehouse = Warehouse.new(warehouse_params)

    if warehouse.save
      render json: {
        message: "Created a warehouse with #{warehouse.total_bins} bins"
      }, status: :created
    else
      render json: warehouse.errors, status: unprocessable_entity
    end
  end

  private

  def warehouse_params
    params.require(:warehouse).permit(:total_bins)
  end
end
