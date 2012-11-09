class CreateBundleDiscounts < ActiveRecord::Migration
  def change
    create_table :bundle_discounts do |t|
      t.string :name
      t.float :discount
      t.boolean :multiply
      t.datetime :active_until

      t.timestamps
    end
  end
end
