class CreateConcepts < ActiveRecord::Migration
  def change
    create_table :concepts do |t|
      t.string :name
      t.string :relevance
      t.string :typeHierarchy
      t.string :geo
      t.string :website
      t.references :place, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
