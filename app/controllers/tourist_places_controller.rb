class TouristPlacesController < ApplicationController
require 'json'
require 'open_weather'
require 'httparty'
require 'nokogiri'
require 'wikipedia'
require 'faker'
  def index

    @places_name = Place.all
    @names=[]
    
    @places_name.each do |place|
      if place.name != "3"
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
    @place_id = params[:id]
    @place = TouristPlace.find_by(:id => @place_id)
    @reviews = @place.reviews.order(review_date: :desc).paginate(:page => params[:page], :per_page => 5)
    Faker::Config.locale = 'en-IND'
    @names1 = Array.new
    @names2 = Array.new
    @entities = Hash.new 
    #Pry.start(binding)
    @sentiments={"positive" =>0,"negative" => 0, "neutral" => 0}
      
      reviews = @place.reviews
      reviews.each do |review|
        @names1.push(Faker::Name.name)
        @names2.push(Faker::Name.name)
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
              

                if @entities.has_key?(entities[i])
                  arr = @entities[entities[i]]
                  #arr[0] = count
                  #arr[1] = positive count
                  #arr[2] = neutral count
                  #arr[3] = negative count
                  #arr[4] = type
                  arr[0] = arr[0] + counts[i].to_i
                  if(sentiments[i] == "positive")
                    arr[1] = arr[1] + 1 
                  elsif (sentiments[i] == "neutral")
                    arr[2] = arr[2] + 1
                  else 
                    arr[3] = arr[3] + 1
                  end
                  arr[4] = types[i]
                  if arr[1] > arr[2] && arr[1] > arr[3]
                    arr[5] = 0
                  elsif arr[2] > arr[3] && arr[2] > arr[1]
                    arr[5] = 1
                  else
                    arr[5] = 2
                  end
                  @entities[entities[i]] = arr 

                else
                  arr = Array.new(6,0)
                  arr[0] = arr[0] + counts[i].to_i
                  if(sentiments[i] == "positive")
                    arr[1] = arr[1] + 1 
                  elsif (sentiments[i] == "neutral")
                    arr[2] = arr[2] + 1
                  else 
                    arr[3] = arr[3] + 1
                  end
                  arr[4] = types[i]
                  if arr[1] > arr[2] && arr[1] > arr[3]
                    arr[5] = 0
                  elsif arr[2] > arr[3] && arr[2] > arr[1]
                    arr[5] = 1
                  else
                    arr[5] = 2
                  end
                  
                  @entities[ entities[i] ] = arr 
                end   
              
              rescue
                #Pry.start(binding)
              end
            end
        end
       end
       
      end
      @entities = @entities.sort_by{ |_key,value| value[0]}.reverse
      #@entities = @entities.first(14)
      
    @weather = Hash.new
    #get_weather
    @solutions = Solution.all.order(created_at: :desc).paginate(:page => params[:page], :per_page => 10)
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




end
