require 'rails_helper'

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
