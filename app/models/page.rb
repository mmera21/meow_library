class Page < ApplicationRecord
  validates :title, :content, presence: true
  validates :slug, presence: true, uniqueness: true,
                   format: { with: /\A[a-z0-9-]+\z/, message: "only lowercase letters, numbers and dashes" }
end