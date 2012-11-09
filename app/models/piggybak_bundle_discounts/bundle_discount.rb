module PiggybakBundleDiscounts
  class BundleDiscount < ActiveRecord::Base
    has_and_belongs_to_many :sellables
    attr_accessible :active_until, :discount, :multiply, :name
  
    def is_active?
      active_until.nil? || DateTime.now > active_until
    end

  end
end
