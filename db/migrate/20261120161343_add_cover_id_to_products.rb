class AddCoverIdToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :cover_id, :integer
  end
end
