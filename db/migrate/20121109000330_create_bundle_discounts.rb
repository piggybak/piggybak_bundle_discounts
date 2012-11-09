class CreateBundleDiscounts < ActiveRecord::Migration
  def up
    create_table :bundle_discounts do |t|
      t.string :name, :null => false
      t.float :discount, :null => false
      t.boolean :multiply, :null => false
      t.datetime :active_until

      t.timestamps
    end
    
    create_table :bundle_discounts_sellables, :id => :false do |t|
      t.integer :bundle_discount_id
      t.integer :sellable_id
    end
  end

  def down
    drop_table :bundle_discounts
    drop_table :bundle_discounts_sellables
  end
end
