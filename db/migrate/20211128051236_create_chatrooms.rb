class CreateChatrooms < ActiveRecord::Migration[5.2]
  def change
    create_table :chatrooms do |t|
      t.string :name, null: false
      t.timestamps

      t.timestamps
    end
  end
end
