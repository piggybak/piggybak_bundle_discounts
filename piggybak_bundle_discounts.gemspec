$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "piggybak_bundle_discounts/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "piggybak_bundle_discounts"
  s.version     = PiggybakBundleDiscounts::VERSION
  s.authors     = ["Barrett Griffith, Steph Skardal"]
  s.email       = ["piggybak@endpoint.com"]
  s.homepage    = "http://www.piggybak.org/"
  s.summary     = "Bundle Discount Support in Piggybak."
  s.description = "Bundle Discount Support in Piggybak."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
end
