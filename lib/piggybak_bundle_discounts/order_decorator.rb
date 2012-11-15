module PiggybakBundleDiscounts  
  module OrderDecorator
    extend ActiveSupport::Concern
    
    included do
      after_validation :discount_bundles
    end
      
    def discount_bundles
      line_items.bundle_discounts.each { |bd| bd.mark_for_destruction }

      sellables = line_items.sellables.collect{ |li| li.sellable }
      bundle_discount = PiggybakBundleDiscounts::BundleDiscount.applicable_bundle_discounts(sellables)

      if bundle_discount.present?
        line_items << Piggybak::LineItem.new({ 
          :line_item_type => "bundle_discount", 
          :description => "Bundle Discount", 
          :price => -1*bundle_discount.discount 
        })
      end
    end
  end 
end

