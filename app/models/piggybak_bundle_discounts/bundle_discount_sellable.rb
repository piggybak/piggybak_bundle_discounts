module PiggybakBundleDiscounts
  class BundleDiscountSellable < ActiveRecord::Base
    belongs_to :bundle_discount
    belongs_to :sellable, :class_name => "::Piggybak::Sellable"

    validates_presence_of :sellable_id

    def admin_label
      self.sellable.nil? ? "New Record" : "#{self.sellable.description.gsub('"', '&quot;')}"
    end    
  end
end
