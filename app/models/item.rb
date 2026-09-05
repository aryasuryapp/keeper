class Item < ApplicationRecord
  validates :sku, presence: true, uniqueness: true

  belongs_to :category
end
