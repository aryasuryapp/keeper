class Warehouse < ApplicationRecord
  validates :total_bins, presence: true

  has_many :bins, dependent: :destroy
end
