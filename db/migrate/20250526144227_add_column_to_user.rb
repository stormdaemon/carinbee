class AddColumnToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :age, :integer
    add_column :users, :address, :text
  end
end
