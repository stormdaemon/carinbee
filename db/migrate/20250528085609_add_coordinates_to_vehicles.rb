class AddCoordinatesToVehicles < ActiveRecord::Migration[7.1]
  def change
    add_column :vehicles, :longitude, :float
    add_column :vehicles, :latitude, :float
  end
end
