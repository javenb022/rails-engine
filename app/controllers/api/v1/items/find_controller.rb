class Api::V1::Items::FindController < ApplicationController
  def search
    item = Item.find_all(name: params[:name], min_price: params[:min_price], max_price: params[:max_price])
    if item
      render json: ItemSerializer.new(item)
    else
      render json: { data: {} }, status: 200
    end
  end
end