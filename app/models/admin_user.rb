class AdminUser < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  def self.ransackable_attributes(_auth_object = nil)
    %w[email created_at current_sign_in_at sign_in_count]
  end
end