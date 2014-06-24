class CreateStatus < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :body, null: false 
      t.string :twitter_status_id, unique: true, null: false 
      t.string :twitter_user_id, null: false 
    end
    
    add_index :statuses, :twitter_user_id
  end
end
