class MenuItem < ApplicationRecord
  enum category: %i[appetizer main_course side dessert]
  has_many :order_items
  has_many :orders, through: :order_items
end
