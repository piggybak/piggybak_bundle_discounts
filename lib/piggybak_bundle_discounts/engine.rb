require 'piggybak_bundle_discounts/order_decorator'

module PiggybakBundleDiscounts
  class Engine < ::Rails::Engine
    isolate_namespace PiggybakBundleDiscounts
    
    config.before_initialize do
      Piggybak.config do |config|
        config.line_item_types[:bundle_discount] = { :visible => true,
                                                        :allow_destroy => true,
                                                        :fields => ["bundle_discount"],
                                                        :class_name => "::PiggybakBundleDiscounts::BundleDiscount",
                                                        :display_in_cart => "Bundle Discount",
                                                        :sort => config.line_item_types[:payment][:sort]
                                                      } 
        config.line_item_types[:payment][:sort] += 1
      end
    end
    
    config.to_prepare do
      Piggybak::Order.send(:include, ::PiggybakBundleDiscounts::OrderDecorator)
    end

    initializer "piggybak_bundle_discounts.rails_admin_config" do |app|
      RailsAdmin.config do |config|
        config.model PiggybakBundleDiscounts::BundleDiscount do
          navigation_label "Orders"
          label "Bundle Discounts"
        
          edit do
            field :name
            field :multiply
            field :discount
            field :sellables do
              partial 'piggybak_bundle_discounts/sellables'
            end
            field :active_until
          end

        end
      end
    end
  
  end
end
