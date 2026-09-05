class Item < ApplicationRecord
  validates :sku, presence: true, uniqueness: true

  # TODO: delete item, delete bin

  belongs_to :category
end
