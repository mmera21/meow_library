class Product < ApplicationRecord
    has_many :product_categories, dependent: :destroy
    has_many :categories, through: :product_categories
    has_many :order_items, dependent: :restrict_with_error

    validates :title, :author, :description, presence: true
    validates :title, :author, length: { maximum: 255 }
    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :sale_price, numericality: { greater_than: 0 }, allow_nil: true
    validates :sale_price, presence: true, if: :on_sale?
    validates :on_sale, inclusion: { in: [true, false] }
    validates :open_library_key, uniqueness: true, allow_nil: true
    validate :sale_price_lower_than_price
    validates :cover_id, numericality: { only_integer: true }, allow_nil: true

    def current_price
        on_sale? && sale_price.present? ? sale_price : price
    end

    def self.ransackable_attributes(_auth_object = nil)
        %w[title author price on_sale created_at updated_at]
    end

    def self.ransackable_associations(_auth_object = nil)
        %w[categories]
    end

    private

    def sale_price_lower_than_price
        return if sale_price.blank? || price.blank?

    errors.add(:sale_price, "must be lower than the regular price") if sale_price >= price
  end
end