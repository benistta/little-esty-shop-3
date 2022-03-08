require 'rails_helper'

RSpec.describe 'Bulk discounts index page' do

  before :each do
    @merchant = Merchant.create!(name: "Ana Maria")
    @discount_1 = BulkDiscount.create!(percentage_discount: 0.5, quantity_threshold: 15, merchant_id: @merchant.id)
    @discount_2 = BulkDiscount.create!(percentage_discount: 0.10, quantity_threshold: 30, merchant_id: @merchant.id)
  end

  it "when visiting the merchant bulk discounts index" do
      visit merchant_dashboard_index_path(@merchant)
      expect(page).to have_link("##{@merchant.name}'s bulk discounts")

      click_on("#{@merchant.name}'s bulk discounts")

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
      # expect(page).to have_content("#{@merchant.name}'s bulk discounts")
      visit merchant_bulk_discounts_path(@merchant)

      within("#bulk_discount-#{@discount_1.id}") do
        expect(page).to have_content(@discount_1.percentage_discount)
        expect(page).to have_content(@discount_1.quantity_threshold)
        click_on "#{@discount_1.percentage_discount}"
        expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount_1))
      end

      visit merchant_bulk_discounts_path(@merchant)

      within("#bulk_discount-#{@discount_2.id}") do
        expect(page).to have_content(@discount_2.percentage_discount)
        expect(page).to have_content(@discount_2.quantity_threshold)
        click_on "#{@discount_2.percentage_discount}"
        expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount_2))
      end
  end


  it "displays next 3 upcoming holidays" do
     merchant = Merchant.create!(name: 'Ana Maria')

     holiday_1 = Holiday.new({name: "Good Friday", date: "2022-04-15"})
     holiday_2 = Holiday.new({name: "Memorial Day", date: "2022-05-30"})
     holiday_3 = Holiday.new({name: "Juneteenth", date: "2022-06-20"})

     visit merchant_bulk_discounts_path(@merchant.id)

     expect(page).to have_content("Upcoming Holidays")

     expect(page).to have_content(holiday_1.name)
     expect(page).to have_content(holiday_1.date)
     expect(page).to have_content(holiday_2.name)
     expect(page).to have_content(holiday_2.date)
     expect(page).to have_content(holiday_3.name)
     expect(page).to have_content(holiday_3.date)
   end
end
