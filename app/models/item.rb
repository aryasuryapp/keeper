class Item < ApplicationRecord
  validates :sku, presence: true, uniqueness: true
end
