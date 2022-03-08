class InvoiceItem < ApplicationRecord
  enum status: { pending: 0, packaged: 1, shipped: 2 }
  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item

  def get_name_from_invoice
    item.name
  end

  def full_revenue
    ((unit_price * quantity)/100).round
  end

  def display_price
    cents = self.unit_price
    '%.2f' % (cents / 100.0)
  end

  def applied_discount
    price = item.unit_price
    item.merchant.bulk_discounts.order(percentage_discount: :desc, quantity_threshold: :desc).each do |discount|
      if quantity >= discount.quantity_threshold
        percent = discount.percentage_discount
        price = price - (percent * item.unit_price)
        break
      end
    end
    price
    end


    def self.discount_revenue
      all.map do |invoice_item|
        (invoice_item.quantity * invoice_item.applied_discount)
      end.sum
    end
end
