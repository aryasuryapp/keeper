module Api
  module V1
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
          render json: warehouse.errors, status: :unprocessable_entity
        end
      end

      def status
        # Given only have 1 warehouse
        warehouse = Warehouse.first
        unless warehouse
          raise "No warehouse found"
        end

        bins = ::WarehouseStatusService.new(warehouse.id).call

        render json: bins, status: :ok

      rescue => e
        render json: {
          errors: e
        }, status: :unprocessable_entity
      end

      private

      def warehouse_params
        params.require(:warehouse).permit(:total_bins)
      end
    end
  end
end
