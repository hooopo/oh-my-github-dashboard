class CreatePullRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :pull_requests, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :repo_id
      t.boolean :locked
      t.string :title
      t.boolean :closed
      t.datetime :closed_at
      t.string :state
      t.integer :number
      t.string :author
      t.bigint :user_id
      t.string :author_association
      
      t.boolean :is_draft
      t.integer :additions, default: 0
      t.integer :deletions, default: 0
      t.datetime :merged_at
      t.string :merged_by
      t.integer :changed_files, default: 0
      t.boolean :merged

      t.integer :comments_count, default: 0

      t.timestamps
      
      t.index :updated_at 
      t.index :created_at 
      t.index :author
      t.index :user_id
    end
  end
end