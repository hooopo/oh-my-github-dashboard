class CreateCurrentUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :curr_user, id: false do |t|
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

      t.string :last_issue_cursor 
      t.string :last_pr_cursor
      t.string :last_follower_cursor 
      t.string :last_following_cursor 
      t.string :last_starred_repo_cursor 
      t.string :last_repo_cursor
      t.string :last_commit_comment_cursor 
      t.string :last_issue_comment_cursor
    end
  end
end
