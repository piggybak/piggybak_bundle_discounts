class CreateBundleDiscountsSellables < ActiveRecord::Migration
  def change 
    create_table :bundle_discounts_sellables, :id => :false do |t|
      t.integer :bundle_discount_id
      t.integer :sellable_id
    end
  end
end
