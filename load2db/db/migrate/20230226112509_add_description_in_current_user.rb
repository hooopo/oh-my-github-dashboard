class AddDescriptionInCurrentUser < ActiveRecord::Migration[7.0]
  def change
    add_column :curr_user, :bio, :text
    add_column :curr_user, :story, :text
  end
end
