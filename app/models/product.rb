class Product < ApplicationRecord
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :order_items, dependent: :restrict_with_error

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [150, 225]
    attachable.variant :large, resize_to_limit: [400, 600]
  end

  validates :title, :author, :description, presence: true
  validates :title, :author, length: { maximum: 255 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :sale_price, numericality: { greater_than: 0 }, allow_nil: true
  validates :sale_price, presence: true, if: :on_sale?
  validates :on_sale, inclusion: { in: [true, false] }
  validates :open_library_key, uniqueness: true, allow_nil: true
  validates :cover_id, numericality: { only_integer: true }, allow_nil: true
  validate :sale_price_lower_than_price
  validate :image_must_be_jpeg_png_or_webp

  def self.ransackable_attributes(_auth_object = nil)
    %w[title author price on_sale created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[categories product_categories]
  end

  def current_price
    on_sale? && sale_price.present? ? sale_price : price
  end

  private

  def sale_price_lower_than_price
    return if sale_price.blank? || price.blank?

    errors.add(:sale_price, "must be lower than the regular price") if sale_price >= price
  end

  def image_must_be_jpeg_png_or_webp
    return unless image.attached?
    return if image.content_type.in?(%w[image/jpeg image/png image/webp])

    errors.add(:image, "must be a JPEG, PNG or WebP")
  end
end