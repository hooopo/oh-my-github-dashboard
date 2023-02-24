class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: false do |t|
      t.bigint :id, primary_key: true  # This is the user's GitHub ID
      t.string :login, null: false   # This is the user's GitHub login
    
      t.string :company
      t.string :location
      
      t.string :twitter_username
  
      t.integer :followers_count, default: 0
      t.integer :following_count, default: 0

      t.string :region

      t.string :created_at, null: false
      t.string :updated_at, null: false
    end
  end
end
