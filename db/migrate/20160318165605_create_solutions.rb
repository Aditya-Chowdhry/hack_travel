class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.string :entity
      t.string :title
      t.string :body
      t.integer :type_

      t.timestamps null: false
    end
  end
end
