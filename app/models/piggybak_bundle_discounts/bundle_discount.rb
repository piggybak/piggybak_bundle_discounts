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
      get_max_discount(bundle_discounts) if bundle_discounts.present?
    end
    
  end
end
