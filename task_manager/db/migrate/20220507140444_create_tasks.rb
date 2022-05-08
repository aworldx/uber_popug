class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :description
      t.references :account
      t.string :status

      t.timestamps
    end
  end
end
