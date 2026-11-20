class ProductCategory < ApplicationRecord
  belongs_to :product
  belongs_to :category

  def self.ransackable_attributes(_auth_object = nil)
    %w[product_id category_id]
  end
end