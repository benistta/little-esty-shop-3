require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it {should belong_to(:item)}
    it {should belong_to(:invoice)}
    it {should have_many(:merchants).through(:item)}
  end

  describe 'validations' do
    it { should define_enum_for(:status).with_values([:pending, :packaged, :shipped]) }
  end

  before :each do
    @merchant = Merchant.create!(name: 'BuyMyThings')
    @merchant2 = Merchant.create!(name: 'BuyMyThings')
    @customer1 = Customer.create!(first_name: 'Tired', last_name: 'Person')
    @customer2 = Customer.create!(first_name: 'Tired', last_name: 'Person')

    @invoice1 =Invoice.create!(status: 0, customer_id: @customer1.id)
    @invoice2 =Invoice.create!(status: 0, customer_id: @customer1.id)
    @invoice3 =Invoice.create!(status: 0, customer_id: @customer2.id)

    @item1 = Item.create!(name: 'food', description: 'delicious', unit_price: '2000', merchant_id: @merchant.id)
    @item2 = Item.create!(name: 'more food', description: 'even more delicious', unit_price: '3000', merchant_id: @merchant.id)
    @item3 = Item.create!(name: 'not food at all', description: 'definitely not food', unit_price: '1500', merchant_id: @merchant2.id)

    @invoice_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 2, unit_price: 100, status: 1)
    @invoice_item2 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice2.id, quantity: 2, unit_price: 400, status: 0)
    @invoice_item3 = InvoiceItem.create!(item_id: @item3.id, invoice_id: @invoice3.id, quantity: 2, unit_price: 200, status: 1)
    @invoice_item4 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice1.id, quantity: 2, unit_price: 100, status: 2)
  end

  describe 'instance methods' do
    describe '.get_name_from_invoice' do
      it "lists items names that are on invoices" do
        expect(@invoice_item2.get_name_from_invoice).to eq("more food")
      end
      it 'will change unit price in cents to a diaplay price' do

       expect(@invoice_item4.display_price).to eq('1.00')
      end
    end

    it 'subtotal revenue' do
      merchant = Merchant.create!(name: 'Ana Maria')
      discount_1 = merchant.bulk_discounts.create!(percentage_discount: 0.20, quantity_threshold: 10)
      discount_2 = merchant.bulk_discounts.create!(percentage_discount: 0.30, quantity_threshold: 15)
      customer = Customer.create!(first_name: 'Juan ', last_name: 'Lopez')
      item = merchant.items.create!(name: 'Pie', description: 'Food', unit_price: 11.00)
      invoice = customer.invoices.create!(status: 0)
      invoice_item = InvoiceItem.create!(quantity: 23, unit_price: 11.00, status: 0, invoice_id: invoice.id, item_id: item.id)

      expect(invoice.total_revenue).to eq(253)
    end

      it 'discount revenue' do
        merchant = Merchant.create!(name: 'Ana Maria')

        discount_1 = merchant.bulk_discounts.create!(percentage_discount: 0.20, quantity_threshold: 10)
        discount_2 = merchant.bulk_discounts.create!(percentage_discount: 0.30, quantity_threshold: 15)
        customer = Customer.create!(first_name: 'Juan ', last_name: 'Lopez')
        item = merchant.items.create!(name: 'Pie', description: 'Food', unit_price: 11.0)
        item_2 = merchant.items.create!(name: 'Towels', description: 'Adults', unit_price: 9.0)
        invoice = customer.invoices.create!(status: 0)
        invoice_item = InvoiceItem.create!(quantity: 23, unit_price: 11.0, status: 0, invoice_id: invoice.id, item_id: item.id)
        invoice_item_2 = InvoiceItem.create!(quantity: 16, unit_price: 9.0, status: 0, invoice_id: invoice.id, item_id: item_2.id)


        expect(invoice.invoice_items.discount_revenue).to eq(277.9)
      end
    end
  end
