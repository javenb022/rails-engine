module Api
  module V1
    module Merchants
      class FindAllController < ApplicationController
        def search
          merchant = Merchant.find_by_name(params[:name])
          if merchant.present?
            render json: MerchantSerializer.new(merchant)
          else
            render json: { data: {} }, status: 200
          end
        end
      end
    end
  end
end
