class Category < ApplicationRecord
  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 }
  
  def self.ransackable_attributes(_auth_object = nil)
    %w[name created_at]
  end
end