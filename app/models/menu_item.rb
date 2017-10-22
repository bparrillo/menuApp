class MenuItem < ApplicationRecord
  enum category: %i[appetizer main_course side dessert]
  has_many :order_items
  has_many :orders, through: :order_items
  validates :price, numericality: { greater_than: 0}
end
