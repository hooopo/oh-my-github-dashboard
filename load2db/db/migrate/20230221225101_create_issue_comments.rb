class CreateIssueComments < ActiveRecord::Migration[7.0]
  def change
    create_table :issue_comments, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :repo_id
      t.bigint :user_id
      t.string :author_association
      t.bigint :issue_id
      t.timestamps
    end
  end
end
