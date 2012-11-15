module PiggybakBundleDiscounts
  class BundleDiscountController < ApplicationController
    def apply
      cart = Piggybak::Cart.new(request.cookies["cart"])
      sellables = cart.sellables.collect {|s| s[:sellable]}.map(&:id)
      discounts = ::PiggybakBundleDiscounts::BundleDiscount.applicable_bundle_discounts(sellables)
      
      if discounts.present?
        render :json => { :bundle_discount => true, :amount => discounts.first.discount }
      else
        render :json => { :bundle_discount => false }
      end
    end
  end
end
