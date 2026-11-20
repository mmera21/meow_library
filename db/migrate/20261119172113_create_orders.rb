class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status, default: "pending", null: false
      t.decimal :subtotal, precision: 10, scale: 2
      t.decimal :gst_rate, precision: 5, scale: 4
      t.decimal :pst_rate, precision: 5, scale: 4
      t.decimal :hst_rate, precision: 5, scale: 4
      t.decimal :total, precision: 10, scale: 2
      t.string :shipping_address
      t.string :stripe_payment_id
      t.string :stripe_customer_id

      t.timestamps
    end
  end
end
