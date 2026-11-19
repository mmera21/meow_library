class ChangeOnSaleDefaultOnProducts < ActiveRecord::Migration[7.2]
  def change
    change_column_default :products, :on_sale, from: nil, to: false
    change_column_null :products, :on_sale, false, false
  end
end