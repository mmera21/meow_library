class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :title
      t.string :author
      t.text :description
      t.decimal :price, precision: 8, scale: 2
      t.decimal :sale_price, precision: 8, scale: 2
      t.boolean :on_sale
      t.string :open_library_key

      t.timestamps
    end
    add_index :products, :open_library_key, unique: true
  end
end
