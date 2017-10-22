class CreateMenuItems < ActiveRecord::Migration[5.0]
  def change
    create_table :menu_items do |t|
      t.string :name
      t.string :description
      t.float :price
      t.integer :category

      t.timestamps
    end
  end
end
