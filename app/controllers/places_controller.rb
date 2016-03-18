class PlacesController < ApplicationController
 require 'json'
require 'open_weather'
require 'httparty'
require 'nokogiri'
require 'wikipedia'

  def index

    @places_name = Place.all
    @names=[]
    
    @places_name.each do |place|
      if place.name != "3" && place.tourist_places.size > 0
        state=State.find_by(:id => place.state_id)
        #Pry.start(binding)
        @names.push({id: place.id ,name: place.name + "  (#{state.name})" })
      end

    end

  end

  def create
    Place.create(place_params)
  end

  def new

  end

  def update
  end

  def show
    @place_id=params[:place_id]
    @place=Place.find_by(:id => @place_id)
    @tourist_places = @place.tourist_places.reverse
    
    @entities = Hash.new 
    @problems = Hash.new
    
    @sentiments = {"positive" => 0,"negative" => 0, "neutral" => 0}
    cnt = 0	
    @tourist_places.each do |tourist|
    	reviews = tourist.reviews
    	reviews.each do |review|
    		review = review.analyse_review

    		if review
	    		entities = review.entities.split(",")
	    		counts = review.counts.split(",")
	    		
	    		sentiments = review.sentiments.split(",")
	    		types = review.types.split(",")
	    		
	    		entities.each_index do |i|
	    			if entities[i] != ""
	    				
	    				#Pry.start(binding)
	    				begin
	    				@sentiments[ sentiments[i] ] = @sentiments[ sentiments[i] ] + 1
	    				if sentiments[i] == "negative"
	    					if @problems.has_key?(entities[i])
	    						@problems[entities[i]] += counts[i].to_i
	    					else
	    						@problems[entities[i]] = counts[i].to_i
	    					end		
	    				else

	    					if @problems.has_key?(entities[i])

	    						@entities[entities[i]] += counts[i].to_i
	    					else
	    						@entities[entities[i]] = counts[i].to_i
	    					end		
	    					
	    				end
	    				
	    				rescue
	    					cnt = cnt + 1
	    					#Pry.start(binding)
	    				end
	    			end
    		end

    	 end
    	 
    	end
    	
    end


    @problems = @problems.sort_by{ |_key,value| value}.reverse
    	@entities = @entities.sort_by{ |_key,value| value}.reverse
    	@problems = @problems.first(14)
    	@entities = @entities.first(14)
    	#Pry.start(binding)
      
    #get_weather
    @weather=Hash.new
  end

  def get_sentiment

  end

  
  def get_weather
    options = { units: "metric", APPID: "b24f0cde979fd9e1aa1485dc1279661d" }
    @weather=Hash.new

    @forecast=OpenWeather::Forecast.city("#{@place.name}, IN",options)
    @forecast["list"].each do |f|
      arr=Array.new
      #["temp":298.77,"temp_min":298.77,"temp_max":298.774,"type","desc",icon]
      arr.push(f["main"]["temp"])
      arr.push(f["main"]["temp_min"])
      arr.push(f["main"]["temp_max"])
      arr.push(f["weather"][0]["main"])
      arr.push(f["weather"][0]["description"])
      arr.push(f["weather"][0]["icon"])

      date=f["dt_txt"].to_date.to_s
      @weather[date]=arr
    end
    #binding.pry
  end

def get_wiki

#binding.pry
end


end

