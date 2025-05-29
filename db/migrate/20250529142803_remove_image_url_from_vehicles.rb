class RemoveImageUrlFromVehicles < ActiveRecord::Migration[7.1]
  def change
    remove_column :vehicles, :image_url, :string
  end
end
