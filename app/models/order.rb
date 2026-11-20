class Order < ApplicationRecord
  STATUSES = %w[pending paid shipped].freeze

  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :subtotal, :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :gst_rate, :pst_rate, :hst_rate, presence: true,
                                             numericality: { greater_than_or_equal_to: 0, less_than: 1 }
  validates :shipping_address, presence: true

  def gst_amount
    (subtotal * gst_rate).round(2)
  end

  def pst_amount
    (subtotal * pst_rate).round(2)
  end

  def hst_amount
    (subtotal * hst_rate).round(2)
  end
end