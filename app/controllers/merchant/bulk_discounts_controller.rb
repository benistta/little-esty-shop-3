class Merchant::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])

    response = Faraday.new('https://date.nager.at/').get('api/v2/NextPublicHolidays/us')
    json = JSON.parse(response.body, symbolize_names: true)
    
    @holidays = json[0..2].map do |data|
      Holiday.new(data)
    end
  end

  def show
   @discount = BulkDiscount.find(params[:id])
   @merchant = Merchant.find(params[:merchant_id])
  end

  def edit
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    # @merchant = Merchant.find(params[:merchant_id])
    discount = BulkDiscount.find(params[:id])
    discount.update(percentage_discount: params[:bulk_discount][:percentage_discount], quantity_threshold: params[:bulk_discount][:quantity_threshold])
    redirect_to merchant_bulk_discount_path(discount.merchant.id, discount.id)
  end

  def new
    @discount = BulkDiscount.new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    bulk_discount = params[:bulk_discount]
    BulkDiscount.create(percentage_discount: bulk_discount[:percentage_discount], quantity_threshold: bulk_discount[:quantity_threshold], merchant: @merchant)
    redirect_to merchant_bulk_discounts_path(@merchant)
  end


  def destroy
    @merchant = Merchant.find_by(id: params[:merchant_id])
    BulkDiscount.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path(@merchant.id)
  end

end
