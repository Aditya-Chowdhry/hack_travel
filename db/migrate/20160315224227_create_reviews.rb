class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.date :review_date
      t.text :review_body
      t.references :tourist_place, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
