class CreateDiscounts < ActiveRecord::Migration[6.1]
  def change
    create_table :discounts do |t|
      t.string :coupon_code
      t.integer :discount_amount
      t.string :discount_type
      t.datetime :expiration_date
      t.integer :free_item_count
      t.integer :product_id

      t.timestamps
    end
  end
end
