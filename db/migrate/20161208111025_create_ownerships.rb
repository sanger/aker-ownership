class CreateOwnerships < ActiveRecord::Migration[5.0]
  def change
    create_table :ownerships, id: false do |t|
      t.string :model_id, null: false, primary_key: true
      t.string :model_type, null: false
      t.string :owner_id, null: false
      t.timestamps
    end
  end
end
