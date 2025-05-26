class CreateVehicles < ActiveRecord::Migration[7.1]
  def change
    create_table :vehicles do |t|
      t.string :brand
      t.string :model
      t.integer :daily_price
      t.text :localization
      t.integer :number_of_places
      t.string :category
      t.string :fuel_type
      t.integer :kilometers
      t.text :description
      t.boolean :available
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
