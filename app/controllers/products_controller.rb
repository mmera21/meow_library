class ProductsController < ApplicationController
  def index
    @products = Product.with_attached_image.order(:title)
  end

  def show
    @product = Product.includes(:categories).find(params[:id])
  end
end