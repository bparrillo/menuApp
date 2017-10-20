class MenuItem < ApplicationRecord
  enum category: [ :appetizer, :main_course, :side, :dessert ]
end
