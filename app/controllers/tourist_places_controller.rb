class TouristPlacesController < ApplicationController
require 'json'
require 'open_weather'
require 'httparty'
require 'nokogiri'
require 'wikipedia'

  def index

    @places_name=Place.all
    @names=[]
    @places_name.each do |place|
      if place.name != "3"
        state=State.find_by(:id => place.state_id)
        @names.push({id: place.id, name: place.name+"  (#{state.name})"})

      end
    end

  #      @names = @names.map { |city| [city[:id], city[:name]] }
  #  binding.pry
  #  @states_name.each do |state|
  #    @names.push(state.name+" State")
  #  end

    #@names=@names.sort

    #logger.debug "#{@names.inspect}"

  end

  def create
    Place.create(place_params)

  end

  def new

  end

  def update
  end

  def show
    #binding.pry
    @place_id=params[:place_id]
    @place=Place.find_by(:id => @place_id)
    @data=[]
  #  binding.pry
    get_sentiment
    get_weather
    #get_wiki

  end

  def get_sentiment
    #Get sentiments
    size=@place.reviews.size
  #  binding.pry
    data=[]
    if(size > 5000)

      i=0
      j=5000

      cnt=0
      while(i+j<size)
        if(cnt==5)
        break
        end
        cnt=cnt+1
        data.push(@place.reviews[i,j])
        i=i+5001
      end
    else
      data.push(@place.reviews)
    end

    @entities=Hash.new
    # text => [type,sentiment,relevance,count]
    @concepts=[]
      @sentiments={"positive"=> 0, "neutral" => 0 ,"negative" => 0}
    data.each do |d|
  #    binding.pry
    #sentiment_url='http://gateway-a.watsonplatform.net/calls/text/TextGetTextSentiment?apikey=c537addbf85ab414ce4d65809acc0b01a79b7a95&text=' + d + '&outputMode=json&sentiment=1'
  #  entity_url='http://access.alchemyapi.com/calls/text/TextGetRankedNamedEntities?apikey=c537addbf85ab414ce4d65809acc0b01a79b7a95&text=' + d + '&outputMode=json&sentiment=1'

    entity_url='http://access.alchemyapi.com/calls/text/TextGetRankedNamedEntities?apikey=ac0e472ffdb38e2768b8c364eaee95a40d8b978d&text=' + d + '&outputMode=json&sentiment=1'

    concept_url='http://gateway-a.watsonplatform.net/calls/text/TextGetRankedConcepts?apikey=ac0e472ffdb38e2768b8c364eaee95a40d8b978d&text=' + d + '&outputMode=json&knowledgeGraph=1'
  #  sentiment_url=URI.escape(sentiment_url)
    entity_url=URI.escape(entity_url)
    concept_url=URI.escape(concept_url)
  #  @sentiment_reponse=HTTParty.post(sentiment_url,
  #    :headers => {"Content-Type" => "application/x-www-form-urlencoded"}
  #   )
     @entity_reponse=HTTParty.post(entity_url,
       :headers => {"Content-Type" => "application/x-www-form-urlencoded"}
      )
      @concept_reponse=HTTParty.post(concept_url,
        :headers => {"Content-Type" => "application/x-www-form-urlencoded"}
       )
    #   binding.pry
  #  @sentiment=JSON.parse(@sentiment_reponse.body)
    @concepts.push(@concept_reponse)

    @entity=JSON.parse(@entity_reponse.body)


    #binding.pry
    @entity["entities"].each do |a|
      if @entities.has_key?(a["text"])
          @entities[a["text"]][3] = (@entities[a["text"]][3].to_i + a["count"].to_i).to_s
          @entities[a["text"]][2] = ((@entities[a["text"]][2].to_f + a["relevance"].to_f)/2).to_s
      else
          arr=Array.new
          arr.push(a["type"])
          arr.push(a["sentiment"]["type"])
          arr.push(a["relevance"])
          arr.push(a["count"])
          @entities[a["text"]]=arr
          @sentiments[a["sentiment"]["type"]]= @sentiments[a["sentiment"]["type"]] + 1

          #binding.pry
      end
    end

   end

   @entities=@entities.sort_by{|k,v| v[3].to_i }.reverse.to_h
   @concepts_final=Hash.new
   @concepts.each do |concept|
     concept["concepts"].each do |c|
       @concepts_final[c["text"]]=c
     end
   end

  # binding.pry
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
  @data=Hash.new
  i=0
  @entities.each do |k,v|
    if i==2
      break
    end
    arr=Array.new
    page=Wikipedia.find(k)

    arr.push(page.title)

    arr.push(page.image_urls)

    @data[k] =arr
    i=i+1
  end
#binding.pry
end


end
