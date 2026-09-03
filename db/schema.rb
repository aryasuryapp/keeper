# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_03_020020) do
  create_table "bins", force: :cascade do |t|
    t.integer "bin_number"
    t.datetime "created_at", null: false
    t.boolean "filled"
    t.datetime "updated_at", null: false
    t.integer "warehouse_id"
    t.index ["warehouse_id"], name: "index_bins_on_warehouse_id"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer "bin_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.string "sku"
    t.datetime "updated_at", null: false
    t.index ["bin_id"], name: "index_items_on_bin_id"
    t.index ["category_id"], name: "index_items_on_category_id"
  end

  create_table "warehouses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "total_bins"
    t.datetime "updated_at", null: false
  end
end
