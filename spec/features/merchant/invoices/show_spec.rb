require 'rails_helper'

RSpec.describe 'The Merchant Invoice Show Page' do
  before :each do
    @merchant = Merchant.create!(name: 'The Duke')
    @merchant2 = Merchant.create!(name: 'The Fluke')
    @customer1 = Customer.create!(first_name: 'Tired', last_name: 'Person')
    @customer2 = Customer.create!(first_name: 'Tired', last_name: 'Person')
    @invoice1 =Invoice.create!(status: 0, customer_id: @customer1.id)
    @invoice2 =Invoice.create!(status: 0, customer_id: @customer2.id)
    @item1 = Item.create!(name: 'food', description: 'delicious', unit_price: '2000', merchant_id: @merchant.id)
    @item2 = Item.create!(name: 'literal goop', description: 'delicious', unit_price: '4000', merchant_id: @merchant2.id)
    @invoice_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 2, unit_price: 100, status: 1)
    @invoice_item2 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 2, unit_price: 2000, status: 1)
    @invoice_item3 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice2.id, quantity: 2, unit_price: 500, status: 1)
  end

  it 'displays all information related to that invoice' do
    visit merchant_invoice_path(@merchant.id, @invoice1.id)
    expect(page).to have_content("Merchant Invoices Show Page")
    expect(page).to have_content(@invoice1.id)
    expect(page).to have_content(@invoice1.status)
    expect(page).to have_content(@invoice1.format_created_at(@invoice1.created_at))
    expect(page).to have_content(@invoice1.customer_name)
    expect(page).to have_no_content(@invoice2.id)
  end

  it 'displays status as a select field that can update the items status' do
    visit merchant_invoice_path(@merchant.id, @invoice1.id)
    expect(page).to have_content(@invoice_item1.status)
    expect(@invoice_item1.status).to eq("packaged")
    within("div#id-#{@invoice_item1.id}") do
      expect(page).to have_button("Update Item Status")
      select "shipped", :from => "status"
      click_button("Update Item Status")
      @invoice_item1.reload
      expect(page).to have_content ("shipped")
    end
    expect(page).to have_content ("Item Status Has Been Updated!")
  end
end


describe 'Discounted revenue' do

  it 'can see discounted revenue from invoice ' do
    merchant = Merchant.create!(name: 'Ana Maria')
    discount_1 = merchant.bulk_discounts.create!(percentage_discount: 0.20, quantity_threshold: 10)
    discount_2 = merchant.bulk_discounts.create!(percentage_discount: 0.30, quantity_threshold: 15)
    customer = Customer.create!(first_name: 'Juan ', last_name: 'Lopez')
    item = merchant.items.create!(name: 'Pie', description: 'Food', unit_price: 11.00)
    invoice = customer.invoices.create!(status: 0)
    invoice_item = InvoiceItem.create!(quantity: 23, unit_price: 11.00, status: 0, invoice_id: invoice.id, item_id: item.id)

    visit  merchant_invoice_path(merchant.id, invoice.id)

    expect(page).to have_content('Total Revenue: $253')

    expect(page).to have_content('Total After Discount: $177')
  end


  it 'can see a link to the show page for the bulk discount that was applied' do
    merchant = Merchant.create!(name: 'Ana Maria')
    discount_1 = merchant.bulk_discounts.create!(percentage_discount: 0.20, quantity_threshold: 10)
    discount_2 = merchant.bulk_discounts.create!(percentage_discount: 0.30, quantity_threshold: 15)
    customer = Customer.create!(first_name: 'Juan ', last_name: 'Lopez')
    item = merchant.items.create!(name: 'Pie', description: 'Food', unit_price: 11.00)
    invoice = customer.invoices.create!(status: 0)
    invoice_item = InvoiceItem.create!(quantity: 23, unit_price: 11.00, status: 0, invoice_id: invoice.id, item_id: item.id)

    visit  merchant_invoice_path(merchant.id, invoice.id)

    expect(page).to have_link('View Discount', count: 1)

    click_on('View Discount')

    expect(current_path).to eq(merchant_bulk_discount_path(merchant.id, discount_1.id))
    end
  end
