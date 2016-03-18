class AddNameToSolution < ActiveRecord::Migration
  def change
    add_column :solutions, :name, :string
    add_column :solutions, :tourist_place_id, :integer
  end
end
