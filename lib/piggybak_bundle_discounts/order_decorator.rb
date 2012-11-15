module PiggybakBundleDiscounts  
  module OrderDecorator
    extend ActiveSupport::Concern
    
    included do
      after_validation :discount_bundles
      def apply_bundle_discount_line_items(discounts)
        # TODO Determine if there are matching bundle discounts
        # max_discount = PiggybakBundleDiscounts::BundleDiscount.get_max_discount(discounts)
        discounts.each do |bd|
          line_items << Piggybak::LineItem.new({ 
            :line_item_type => "bundle_discount", 
            :description => "Bundle Discount", 
            :price => -bd.discount 
          })
        end
      end      
    end

    def discount_bundles
      line_items.bundle_discounts.each { |bd| bd.mark_for_destruction }
      sellables = line_items.sellables.map(&:sellable_id)
      discounts = PiggybakBundleDiscounts::BundleDiscount.applicable_bundle_discounts(sellables)
      apply_bundle_discount_line_items(discounts) if discounts.present?
      
    end
  end 
end

