class TouristPlacesController < ApplicationController
require 'json'
require 'open_weather'
require 'httparty'
require 'nokogiri'
require 'wikipedia'

  def index

    @places_name=Place.all.order("LENGTH(reviews) DESC")
    @names=[]
    @places_name.each do |place|
      if place.name != "3"
        state=State.find_by(:id => place.state_id)
        @names.push({id: place.id, name: place.name+"  (#{state.name})"})
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
    @entities=@place.entities.all
    @concepts=@place.concepts.all
    @wikis=@place.get_places.all
    @wikipedia=[]
    @wikis.each do |wiki|
      if wiki.title!= "India" && wiki.title.upcase != @place.name.upcase
        @wikipedia.push(wiki)
      end
    end
    @sentiments={"positive" =>0,"negative" => 0, "neutral" => 0}
    @entities.each do |entity|
      @sentiments[entity.sentiment]= @sentiments[entity.sentiment] + 1
    end
    get_weather

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
