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
    end

    def discount_bundles
      line_items.bundle_discounts.each { |bd| bd.mark_for_destruction }
      Rails.logger.info  "line_items.sellables:#{line_items.sellables}"
      sellables = line_items.sellables.map(&:sellable_id)
      discounts = PiggybakBundleDiscounts::BundleDiscount.applicable_bundle_discounts(sellables)
      apply_bundle_discount_line_items(discounts)
      
      
    end
  end 
end

