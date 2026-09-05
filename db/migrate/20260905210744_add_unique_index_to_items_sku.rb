class AddUniqueIndexToItemsSku < ActiveRecord::Migration[8.1]
  def change
    add_index :items, :sku, unique: true
  end
end
