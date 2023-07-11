class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  # def show
  #   render json: MerchantSerializer.new(Item.find(params[:id]).merchant)
  # end
end