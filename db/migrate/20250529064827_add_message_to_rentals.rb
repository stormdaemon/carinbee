class AddMessageToRentals < ActiveRecord::Migration[7.1]
  def change
    add_column :rentals, :message, :text
  end
end
