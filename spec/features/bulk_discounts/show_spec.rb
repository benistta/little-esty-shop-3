require 'rails_helper'
# Merchant Bulk Discount Show
#
# As a merchant
# When I visit my bulk discount show page
# Then I see the bulk discount's quantity threshold and percentage discount
RSpec.describe "Bulk Discount show page" do

  before :each do
    @merchant = Merchant.create!(name: "Ana Maria")
    @discount_1 = BulkDiscount.create!(percentage_discount: 0.5, quantity_threshold: 15, merchant_id: @merchant.id)
    @discount_2 = BulkDiscount.create!(percentage_discount: 0.10, quantity_threshold: 30, merchant_id: @merchant.id)
    @discount_3 = BulkDiscount.create!(percentage_discount: 0.20, quantity_threshold: 40, merchant_id: @merchant.id)
  end

    it 'see the bulk discounts quantity threshold and percentage discount' do

      visit merchant_bulk_discount_path(@merchant.id, @discount_1.id)
      expect(page).to have_content(@discount_1.percentage_discount)
      expect(page).to have_content(@discount_1.quantity_threshold)
    end

#     Merchant Bulk Discount Edit
#
# As a merchant
# When I visit my bulk discount show page
# Then I see a link to edit the bulk discount
# When I click this link
# Then I am taken to a new page with a form to edit the discount
# And I see that the discounts current attributes are pre-poluated in the form
# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated

  it 'can see a form to edit the discounts' do
    visit merchant_bulk_discount_path(@merchant.id, @discount_1.id)

    expect(page).to have_link('Edit Discount')
    click_link('Edit Discount')

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant.id, @discount_1.id))
    fill_in('Percentage discount', with: '0.15')
    fill_in('Quantity threshold', with: '5')
    click_on('Edit Discount')

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant.id, @discount_1.id))


    expect(page).to have_content('Percentage Discount: 0.15')
    expect(page).to have_content('Quantity threshold: 5')
    expect(page).to_not have_content('Percentage Discount: 0.20')
    expect(page).to_not have_content('Quantity threshold: 10')

  end
end
