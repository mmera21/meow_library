class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @products = @category.products.with_attached_image.order(:title)
  end
end