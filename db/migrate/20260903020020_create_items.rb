class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :sku
      t.references :category
      t.references :bin

      t.timestamps
    end
  end
end
