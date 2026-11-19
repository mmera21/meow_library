class Province < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true, format: { with: /\A[A-Z]{2}\z/, message: "must be 2 capital letters" }
  validates :gst_rate, :pst_rate, :hst_rate, presence: true,
                                             numericality: { greater_than_or_equal_to: 0, less_than: 1 }

  def total_tax_rate
    gst_rate + pst_rate + hst_rate
  end
end