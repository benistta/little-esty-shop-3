class AddItemIdToBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :bulk_discounts, :item
  end
end
