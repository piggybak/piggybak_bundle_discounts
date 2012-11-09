module PiggybakBundleDiscounts
  module LineItemDecorator
    extend ActiveSupport::Concern
  
    has_and_belongs_to_many :bundle_discounts
  end
end