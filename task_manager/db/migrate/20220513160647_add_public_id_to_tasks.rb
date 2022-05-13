class AddPublicIdToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :public_id, :string
  end
end
