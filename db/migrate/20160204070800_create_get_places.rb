class CreateGetPlaces < ActiveRecord::Migration
  def change
    create_table :get_places do |t|
      t.references :place, index: true, foreign_key: true
      t.string :image_url
      t.string :title

      t.timestamps null: false
    end
  end
end
