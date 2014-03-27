PiggybakBundleDiscounts::Engine.routes.draw do
  get "/apply_bundle_discount" => "bundle_discount#apply"
end
