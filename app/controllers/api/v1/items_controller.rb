class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    new_item = Item.create(item_params)
    if new_item.save
      render json: ItemSerializer.new(new_item), status: :created #location: api_v1_item_path(new_item)
    else
      render json: { error: new_item.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      render json: { error: item.errors.full_messages.to_sentence }, status: 400
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    item.invoice_delete
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end