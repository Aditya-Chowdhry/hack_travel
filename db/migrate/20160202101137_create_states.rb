class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.string :link

      t.timestamps null: false
    end
  end
end
