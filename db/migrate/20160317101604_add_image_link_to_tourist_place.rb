class AddImageLinkToTouristPlace < ActiveRecord::Migration
  def change
    add_column :tourist_places, :image_link, :string
    add_column :tourist_places, :summary, :text
  end
end
