module PiggybakBundleDiscounts
  class BundleDiscount < ActiveRecord::Base
    self.table_name = 'bundle_discounts'

    has_and_belongs_to_many :sellables, :class_name => "::Piggybak::Sellable"
    attr_accessible :active_until, :discount, :multiply, :name, :sellable_ids
    validates_presence_of :discount, :name  
    def is_active?
      active_until.nil? || DateTime.now > active_until
    end

  end
end
