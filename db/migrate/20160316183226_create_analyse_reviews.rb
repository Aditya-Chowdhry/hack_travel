class CreateAnalyseReviews < ActiveRecord::Migration
  def change
    create_table :analyse_reviews do |t|
      t.string :entities
      t.string :sentiments
      t.string :counts
      t.string :relevances
      t.string :types
      t.string :scores
      t.decimal :overall_sentitment
      t.references :review, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
