module PiggybakBundleDiscounts  
  module OrderDecorator
    extend ActiveSupport::Concern
    
    included do
      after_validation :discount_bundles
      
      def apply_bundle_discount_line_items(discounts)
        amount = discounts.map(&:discount).inject{|sum,d| sum + d }   
        line_items << Piggybak::LineItem.new({ 
          :line_item_type => "bundle_discount", 
          :description => "Bundle Discount", 
          :price => -amount 
        })
      end  
      
      def discount_bundles
        line_items.bundle_discounts.each { |bd| bd.mark_for_destruction }
        
        sellables = line_items.sellables.collect{ |li| li.sellable }
        discounts = PiggybakBundleDiscounts::BundleDiscount.applicable_bundle_discounts(sellables)
        apply_bundle_discount_line_items(discounts) if discounts.present?
      end
          
    end
  end 
end

