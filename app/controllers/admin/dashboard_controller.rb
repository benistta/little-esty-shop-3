class Admin::DashboardController < ApplicationController
  def index
    @customers = Customer.top_five_customers
    @invoices = Invoice.not_shipped
    # @merchant = Merchant.find(params[:merchant_id])
  end
end
