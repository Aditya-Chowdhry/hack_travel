class AddTypeToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :type_t, :string
  end
end
