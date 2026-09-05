module Api
  module V1
    class BinsController < ApplicationController
      def index
        result = ::BinsService.new(item_params).call
        render json: {
          data: result[:data],
          message: result[:message]
        },
        status: result[:status]
      end

      def show
        item = Item.find_by(sku: params[:id])

        unless item
          return render json: {
            message: "SKU not found"
          }, status: :not_found
        else
          bin = Bin.find(item.bin_id)
        end
        render json: bin.bin_number, status: :ok
      end

      private

      def item_params
        params.permit(:category)
      end
    end
  end
end
