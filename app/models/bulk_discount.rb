class BulkDiscount < ApplicationRecord
  belongs_to :merchant, optional: true
  belongs_to :item, optional: true
end
