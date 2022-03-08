require 'rails_helper'


RSpec.describe 'Merchants Show page' do
  it 'can see all of the items attributes including description, name and price' do
    merchant_1 = Merchant.create!(name: "Ana Maria")
    merchant_2 = Merchant.create!(name: "Juan Lopez")
    item_1 = merchant_1.items.create!(name: "cheese", description: "european cheese", unit_price: 2400)
    item_2 = merchant_2.items.create!(name: "onion", description: "red onion", unit_price: 3400)

    visit "/merchants/#{merchant_1.id}/items"

    click_link "cheese"

    visit "/merchants/#{merchant_1.id}/items/#{item_1.id}"

    expect(page).to have_content(item_1.name)
    expect(page).to have_content(item_1.description)
    expect(page).to have_content(item_1.display_price)
  end

end
