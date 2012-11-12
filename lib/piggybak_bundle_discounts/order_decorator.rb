module PiggybakBundleDiscounts  
  module OrderDecorator
    extend ActiveSupport::Concern
    
    included do
      after_validation :discount_bundles
      
      def get_sellables_from_line_items
        sellables = []
        line_items.each do |li|
           sellables << li.sellable.id if li.line_item_type == "sellable"
        end
        sellables
      end
      
      def bundle_discount_match(bulk_discount, sellables)
        return nil if bulk_discount.sellable_ids.empty?
        if (bulk_discount.sellable_ids-sellables).count == 0
          true
        else
          false
        end
      end
      
      def remove_bundle_discount_line_items
        line_items.bundle_discounts.each { |bd| bd.mark_for_destruction }
      end
      
      def apply_bundle_discount_line_items(ids)
        # TODO Determine if there are matching bundle discounts
        # max_discount = PiggybakBundleDiscounts::BundleDiscount.get_max_discount(ids)
        ids.each do |id|
          bd = PiggybakBundleDiscounts::BundleDiscount.find(id)
          line_items << Piggybak::LineItem.new({ :line_item_type => "bundle_discount", :description => "Bundle Discount", :price => -bd.discount })
        end
      end
      
    end

    def discount_bundles
      
      sellables = get_sellables_from_line_items
      
      discount_ids = []
      PiggybakBundleDiscounts::BundleDiscount.active.each do |bd|
        discount_ids << bd.id if bundle_discount_match(bd, sellables)
      end
      remove_bundle_discount_line_items
      apply_bundle_discount_line_items(discount_ids) if discount_ids.present?
      
    end
    
    
    
  end
  
  
end

