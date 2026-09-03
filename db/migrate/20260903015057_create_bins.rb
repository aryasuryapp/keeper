class CreateBins < ActiveRecord::Migration[8.1]
  def change
    create_table :bins do |t|
      t.integer :bin_number
      t.boolean :filled
      t.references :warehouse

      t.timestamps
    end
  end
end
