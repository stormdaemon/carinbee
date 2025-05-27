class AddColumnToVehicle < ActiveRecord::Migration[7.1]
  def change
    add_column :vehicles, :image_url, :string
  end
end

