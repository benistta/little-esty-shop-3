require 'rails_helper'

RSpec.describe 'Bulk discounts index page' do

  before :each do
    @merchant = Merchant.create!(name: "Ana Maria")
    @discount_1 = BulkDiscount.create!(percentage_discount: 0.5, quantity_threshold: 15, merchant_id: @merchant.id)
    @discount_2 = BulkDiscount.create!(percentage_discount: 0.10, quantity_threshold: 30, merchant_id: @merchant.id)
    @discount_3 = BulkDiscount.create!(percentage_discount: 0.20, quantity_threshold: 40, merchant_id: @merchant.id)
  end

  it 'has link to Create Discount' do
    visit merchant_bulk_discounts_path(@merchant)
    expect(page).to have_link('Create Discount')

    click_link('Create Discount')
  end

  it 'Can create a new discount' do
  visit merchant_bulk_discounts_path(@merchant)

  click_link('Create Discount')
  expect(page).to have_current_path(new_merchant_bulk_discount_path(@merchant))

  fill_in('Percentage discount', with: '0.20')
  fill_in('Quantity threshold', with: '10')
  click_on('Create Bulk discount')

  expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
  expect(page).to have_content('0.2')
  expect(page).to have_content('10')
end
end
