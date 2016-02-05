class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.references :place, index: true, foreign_key: true
      t.string :name
      t.string :sentiment
      t.string :count
      t.string :relevance

      t.timestamps null: false
    end
  end
end
