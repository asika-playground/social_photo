class UserAddFriendlyId < ActiveRecord::Migration
  def change
    add_column :users, :friendly_id, :string, :unique => true
  end
end
