class Product < ApplicationRecord
  has_one :discount
  validates_uniqueness_of :code, :message => '^Product code already exist'
  PROMOTION_TYPES =["Dollar value discount","Percentage discount","BOGO","Free gift","Free shipping"]
end
