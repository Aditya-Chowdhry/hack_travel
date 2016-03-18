module PlacesHelper
	def has_image(name)
    	Rails.application.assets.find_asset (name)
	end
end
