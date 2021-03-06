require 'piggybak_bundle_discounts/order_decorator'

module PiggybakBundleDiscounts
  class Engine < ::Rails::Engine
    isolate_namespace PiggybakBundleDiscounts
    
    config.to_prepare do
       Piggybak::Order.send(:include, ::PiggybakBundleDiscounts::OrderDecorator)
    end
    
    config.before_initialize do
      Piggybak.config do |config|
        config.manage_classes << "::PiggybakBundleDiscounts::BundleDiscount"
        config.extra_secure_paths << "/apply_bundle_discount"
        config.line_item_types[:bundle_discount] = { :visible => false,
                                                     :allow_destroy => false,
                                                     :fields => [],
                                                     :reduce_tax_subtotal => true,
                                                     :class_name => "::PiggybakBundleDiscounts::BundleDiscount",
                                                     :display_in_cart => "Bundle Discount",
                                                     :sort => config.line_item_types[:payment][:sort]
                                                    } 
        config.line_item_types[:payment][:sort] += 1
      end
    end

    initializer "piggybak_bundle_discounts.assets.precompile" do |app|
      app.config.assets.precompile += ['piggybak_bundle_discounts/piggybak_bundle_discounts-application.js']
    end
    
    initializer "piggybak_bundle_discounts.rails_admin_config" do |app|
      RailsAdmin.config do |config|
        config.model PiggybakBundleDiscounts::BundleDiscountSellable do
          label "Sellable"
        end
        config.model PiggybakBundleDiscounts::BundleDiscount do
          navigation_label "Extensions"
          label "Bundle Discounts"
       
          list do
            field :name
            field :discount do
              formatted_value do
                "$%.2f" % value
              end
            end
            #field :multiply
            field :sellables
            field :active_until
          end
 
          edit do
            field :name
            #field :multiply 
            field :discount
            field :active_until
            field :bundle_discount_sellables do 
              active true
              label "Sellables"
              help "Required"
            end
          end

        end
        
        config.model PiggybakBundleDiscounts::BundleDiscountSellable do
          visible false
        
          edit do
            field :sellable do
              
              label "Sellable"
              help "Required"
            end

          end

        end
      end
    end
  
  end
end
