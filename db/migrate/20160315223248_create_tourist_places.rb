class CreateTouristPlaces < ActiveRecord::Migration
  def change
    create_table :tourist_places do |t|
      t.string :name
      t.references :place, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
