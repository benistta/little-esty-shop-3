class Invoice < ApplicationRecord
  enum status: { 'in progress' => 0, cancelled: 1, completed: 2 }
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  scope :with_successful_transactions, -> { joins(:transactions)
  .where("transactions.result =?", 0)}


  def customer_name
    customer = Customer.find(customer_id)
    customer.first_name + " " + customer.last_name
  end

  def invoice_revenue
    (invoice_items.sum("invoice_items.unit_price * invoice_items.quantity"))/100
  end

  def invoice_display_revenue
    (invoice_items.sum("invoice_items.unit_price * invoice_items.quantity"))
  end

  def revenue_display_price
    cents = (invoice_items.sum("invoice_items.unit_price * invoice_items.quantity"))
    '%.2f' % (cents / 100.0)
  end

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discount_revenue
    invoice_items.map do |invoice_item|
      invoice_item.quantity * invoice_item.applied_discount
    end.sum
  end

  def display_date
    self.created_at.strftime("%A, %B %d, %Y")
  end

  def self.not_shipped
                  joins(:invoice_items)
                  .where("invoice_items.status != 2")
                  .group(:id)
                  .order(created_at: :asc)
                  .distinct
  end
end
