class CreateFollowings < ActiveRecord::Migration[7.0]
  def change
    create_table :followings, id: false do |t|
      t.bigint :user_id, null: false
      t.bigint :target_user_id, null: false
      t.index [:user_id, :target_user_id], unique: true
    end
  end
end
