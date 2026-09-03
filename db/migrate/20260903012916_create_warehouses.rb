class CreateWarehouses < ActiveRecord::Migration[8.1]
  def change
    create_table :warehouses do |t|
      t.integer :total_bins

      t.timestamps
    end
  end
end
