class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.string :link
      t.references :state, index: true, foreign_key: true
      t.text :reviews

      t.timestamps null: false
    end
  end
end
