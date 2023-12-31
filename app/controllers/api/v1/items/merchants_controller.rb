module Api
  module V1
    module Items
      class MerchantsController < ApplicationController
        def index
          render json: MerchantSerializer.new(Item.find(params[:item_id]).merchant)
        end
      end
    end
  end
end
