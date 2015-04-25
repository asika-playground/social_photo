class CreateUserPhotoSubscribeships < ActiveRecord::Migration
  def change
    create_table :user_photo_subscribeships do |t|

      t.integer :user_id
      t.integer :photo_id

      t.timestamps null: false
    end
  end
end
