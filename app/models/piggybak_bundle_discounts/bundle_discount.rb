module PiggybakBundleDiscounts
  class BundleDiscount < ActiveRecord::Base
    self.table_name = 'bundle_discounts'

    scope :active, where("active_until IS NULL OR active_until > ?", DateTime.now)

    has_and_belongs_to_many :sellables, :class_name => "::Piggybak::Sellable"
    attr_accessible :active_until, :discount, :multiply, :name, :sellable_ids
    validates_presence_of :discount, :name  
    
    def self.get_max_discount(ids)
       raise "No bundle discounts to evaluate" if ids.nil? || ids.empty?
       PiggybakBundleDiscounts::BundleDiscount.find(ids).sort_by(&:discount).first
    end

  end
end
