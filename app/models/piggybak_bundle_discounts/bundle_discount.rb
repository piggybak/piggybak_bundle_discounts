module PiggybakBundleDiscounts
  class BundleDiscount < ActiveRecord::Base
    self.table_name = 'bundle_discounts'

    scope :active, where("active_until IS NULL OR active_until > ?", DateTime.now)
    has_many :bundle_discount_sellables
    has_many :sellables, :through => :bundle_discount_sellables, :class_name => "::Piggybak::Sellable"
    accepts_nested_attributes_for :bundle_discount_sellables
    attr_accessible :active_until, :discount, :multiply, :name, :sellable_ids, :bundle_discount_sellables_attributes
    validates_presence_of :discount, :name  
    
    def self.get_max_discount(discounts)
       raise "No bundle discounts to evaluate" if discounts.nil? || discounts.empty?
       discounts.sort_by(&:discount).last
    end
    
    def sellables_match_bundle_discount?(order_sellables)
      if sellables.empty?
        return nil
      else
        #Do the bundle's sellables match the order's sellables
        (sellables - order_sellables).empty? ? true : false
      end
    end
    
    def self.applicable_bundle_discounts(order_sellables)
      bundle_discounts = []
      PiggybakBundleDiscounts::BundleDiscount.active.each do |bd|
        bundle_discounts << bd if bd.sellables_match_bundle_discount?(order_sellables)
      end
      filter_discounts(bundle_discounts, order_sellables)
    end
    
    
    def self.filter_discounts(bundle_discounts,sellables)
      
      overlapping_bundles = []
      filtered_discounts = {}
 
      sellables.each do |s|
        bundle_discounts.each do |b|
          overlapping_bundles << b if b.sellables.include?(s)
        end
        
        if overlapping_bundles.count > 1
          filtered_discounts.merge!(s.id => get_max_discount(overlapping_bundles))
        end
        
        overlapping_bundles.clear
      end
      if filtered_discounts.empty?
        return bundle_discounts
      else 
        return filtered_discounts.values.uniq
      end
    end
  end
end
