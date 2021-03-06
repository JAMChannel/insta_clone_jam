class SorceryCore < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email,            null: false
      t.string :crypted_password
      t.string :salt
      t.string :username, null: false
      t.string :avatar
      t.timestamps                null: false
      t.boolean "notification_on_comment", default: true
      t.boolean "notification_on_like", default: true
      t.boolean "notification_on_follow", default: true
    end

    add_index :users, :email, unique: true
  end
end
