class AddSummaryToGetPlaces < ActiveRecord::Migration
  def change
    add_column :get_places, :summary, :text
  end
end
