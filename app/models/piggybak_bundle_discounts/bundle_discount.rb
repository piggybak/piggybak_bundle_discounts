module PiggybakBundleDiscounts
  class BundleDiscount < ActiveRecord::Base
    self.table_name = 'bundle_discounts'

    scope :active, where("active_until IS NULL OR active_until > ?", DateTime.now)

    has_many :bundle_discount_sellables, :dependent => :destroy
    has_many :sellables, :through => :bundle_discount_sellables, :class_name => "::Piggybak::Sellable"

    accepts_nested_attributes_for :bundle_discount_sellables, :allow_destroy => true
    attr_accessible :active_until, :discount, :multiply, :name, :sellable_ids, :bundle_discount_sellables_attributes

    validates_presence_of :discount, :name  
    validates_numericality_of :discount, :greater_than_or_equal_to => 0
    
    def sellables_match_bundle_discount?(sellables_to_match)
      if sellables.empty?
        return nil
      else
        #Do the bundle's sellables match the order's sellables
        (sellables - sellables_to_match).empty?
      end
    end
    
    def self.applicable_bundle_discounts(sellables)
      # Selecting applicable bundle discounts
      bundle_discounts = self.active.select { |bd| bd.sellables_match_bundle_discount?(sellables) }

      # Returning max bundle discount
      bundle_discounts.present? ? bundle_discounts.sort_by(&:discount).last : nil
    end
  end
end
