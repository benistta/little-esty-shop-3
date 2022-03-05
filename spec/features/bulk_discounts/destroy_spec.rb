require 'rails_helper'


RSpec.describe "bulk_discount destroy" do

  before :each do
    @merchant = Merchant.create!(name: "Ana Maria")
    @discount_1 = BulkDiscount.create!(percentage_discount: 0.5, quantity_threshold: 15, merchant_id: @merchant.id)
    @discount_2 = BulkDiscount.create!(percentage_discount: 0.10, quantity_threshold: 30, merchant_id: @merchant.id)
    @discount_3 = BulkDiscount.create!(percentage_discount: 0.20, quantity_threshold: 40, merchant_id: @merchant.id)
  end
#   Merchant Bulk Discount Delete
#
# As a merchant
# When I visit my bulk discounts index
# Then next to each bulk discount I see a link to delete it
# When I click this link
# Then I am redirected back to the bulk discounts index page
# And I no longer see the discount listed
  describe "destroy" do
    it 'can see a link to delete a bulk discount' do

      visit merchant_bulk_discounts_path(@merchant)
      expect(page).to have_content(@discount_1.percentage_discount)
      within("bulk_discount-")
      expect(page).to have_content(@discount_1.percentage_discount)
      expect(page).to have_content(@discount_1.quantity_threshold)
      expect(page).to have_link("Delete #{@discount_1.percentage_discount}")
      click_link("Delete #{@discount_1.percentage_discount}")
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
      expect(page).to_not have_content(@discount_1.percentage_discount)
      expect(page).to_not have_content(@discount_1.quantity_threshold)
    end
  end
end
