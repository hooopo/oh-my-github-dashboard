class CreateCommitComments < ActiveRecord::Migration[7.0]
  def change
    create_table :commit_comments, id: false do |t|
      t.bigint :id, primary_key: true 
      t.bigint :repo_id
      t.bigint :user_id
      t.string :author_association
      t.timestamps
    end
  end
end
