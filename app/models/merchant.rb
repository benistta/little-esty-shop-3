class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items


  def merchant_invoices
    (invoices.order(:id)).uniq
  end 
end
