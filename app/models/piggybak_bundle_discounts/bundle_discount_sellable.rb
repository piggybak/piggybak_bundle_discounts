module PiggybakBundleDiscounts
  class BundleDiscountSellable < ActiveRecord::Base
    self.table_name = 'bundle_discount_sellables'

    belongs_to :bundle_discount
    belongs_to :sellable, :class_name => "::Piggybak::Sellable"
    
  end
end