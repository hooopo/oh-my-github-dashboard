class CreateRepos < ActiveRecord::Migration[7.0]
  def change
    create_table :repos, id: false do |t|
      t.bigint :id, primary_key: true 
      t.string :name 
      t.string :owner 
      t.bigint :user_id
      t.string :license 
      t.boolean :is_private
      t.integer :disk_usage
      t.string :language 
      t.text :description 
      t.boolean :is_fork
      t.bigint :parent_id 
      t.integer :fork_count
      t.integer :stargazer_count
      t.datetime :pushed_at
      t.json :topics
      t.timestamps
    end
  end
end