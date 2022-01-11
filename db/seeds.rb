# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.destroy_all
product1 = Product.create({:name=>"HOODIE", :code => "HOODIE", :price => 20})
product2 = Product.create({:name=>"TSHIRT", :code => "TSHIRT", :price => 15})
product3 = Product.create({:name=>"MUG", :code => "MUG", :price => 6})
Discount.create!(coupon_code: 'MUG',discount_amount: 2, discount_type: "BOGO", free_item_count: 1, product_id: product3.id)
Discount.create!(coupon_code: 'TSHIRT',discount_amount: 30, discount_type: "Percentage discount", free_item_count: nil, product_id: product2.id)
