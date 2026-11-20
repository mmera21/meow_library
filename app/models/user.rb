class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true
  has_many :orders, dependent: :restrict_with_error

  validates :postal_code, format: { with: /\A[A-Za-z]\d[A-Za-z] ?\d[A-Za-z]\d\z/, message: "must look like R3L 1Y5" },
                          allow_blank: true
  validates :address, :city, length: { maximum: 255 }
end