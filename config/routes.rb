PiggybakBundleDiscounts::Engine.routes.draw do
  match "/apply_bundle_discount" => "bundle_discount#apply"
end
