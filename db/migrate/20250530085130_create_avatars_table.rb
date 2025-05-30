class CreateAvatarsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :avatars do |t|
      t.string :url

      t.timestamps
    end
  end
end
