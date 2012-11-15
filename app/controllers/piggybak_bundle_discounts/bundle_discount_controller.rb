module PiggybakBundleDiscounts
  class BundleDiscountController < ApplicationController
    def apply
      cart = Piggybak::Cart.new(request.cookies["cart"])
      sellables = cart.sellables.collect { |s| s[:sellable] }
      discount = ::PiggybakBundleDiscounts::BundleDiscount.applicable_bundle_discounts(sellables)
      
      if discount.present? 
        render :json => { :bundle_discount => true, :amount => discount.discount }
      else
        render :json => { :bundle_discount => false }
      end
    end
  end
end
