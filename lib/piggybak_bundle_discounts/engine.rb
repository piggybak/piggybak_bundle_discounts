module PiggybakBundleDiscounts
  class Engine < ::Rails::Engine
    isolate_namespace PiggybakBundleDiscounts

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
