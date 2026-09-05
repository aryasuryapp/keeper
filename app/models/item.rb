class Item < ApplicationRecord
  validates :sku, presence: true, uniqueness: true

  after_commit :empty_bin, on: :destroy

  belongs_to :category

  private

  def empty_bin
    bin = Bin.find_by(id: self.bin_id)
    if bin
      bin.update!(filled: false)
    end
  end
end
