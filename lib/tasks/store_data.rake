namespace :store_data do
  desc "TODO"
  task alchemy: :environment do
    places=Place.all
    puts "Started"
  #  binding.pry
    places.each do |place|
      puts "#{place.name}..........."
      if(!Entity.exists?(:place_id => place.id))
      data=[]
      size=place.reviews.size
      #binding.pry
      data=[]
      if(size > 1000)

        i=0
        j=1000

        cnt=0
        while(i+j<size)
          if(cnt==5)
          break
          end
          cnt=cnt+1
          data.push(place.reviews[i,j])
          i=i+1001
        end
      else
        data.push(place.reviews)
      end

      entities=Hash.new
      # text => [type,sentiment,relevance,count]
      concepts=[]
      sentiments={"positive"=> 0, "neutral" => 0 ,"negative" => 0}
      data.each do |d|
    #    binding.pry
      #sentiment_url='http://gateway-a.watsonplatform.net/calls/text/TextGetTextSentiment?apikey=c537addbf85ab414ce4d65809acc0b01a79b7a95&text=' + d + '&outputMode=json&sentiment=1'
    #  entity_url='http://access.alchemyapi.com/calls/text/TextGetRankedNamedEntities?apikey=c537addbf85ab414ce4d65809acc0b01a79b7a95&text=' + d + '&outputMode=json&sentiment=1'

      entity_url='http://access.alchemyapi.com/calls/text/TextGetRankedNamedEntities?apikey=ac0e472ffdb38e2768b8c364eaee95a40d8b978d&text=' + d + '&outputMode=json&sentiment=1'

      concept_url='http://gateway-a.watsonplatform.net/calls/text/TextGetRankedConcepts?apikey=ac0e472ffdb38e2768b8c364eaee95a40d8b978d&text=' + d + '&outputMode=json'
    #  sentiment_url=URI.escape(sentiment_url)
      entity_url=URI.escape(entity_url)
      concept_url=URI.escape(concept_url)
    #  @sentiment_reponse=HTTParty.post(sentiment_url,
    #    :headers => {"Content-Type" => "application/x-www-form-urlencoded"}
    #   )
       entity_reponse=HTTParty.post(entity_url,
         :headers => {"Content-Type" => "application/x-www-form-urlencoded"}
        )
        concept_reponse=HTTParty.post(concept_url,
          :headers => {"Content-Type" => "application/x-www-form-urlencoded"}
         )
      #  binding.pry
    #  @sentiment=JSON.parse(@sentiment_reponse.body)

      concepts.push(concept_reponse)

      entity=JSON.parse(entity_reponse.body)
      puts "Response ok:)"

      #binding.pry
      entity["entities"].each do |a|
        if entities.has_key?(a["text"])
            entities[a["text"]][3] = (entities[a["text"]][3].to_i + a["count"].to_i).to_s
            entities[a["text"]][2] = ((entities[a["text"]][2].to_f + a["relevance"].to_f)/2).to_s
        else
            arr=Array.new
            arr.push(a["type"])
            arr.push(a["sentiment"]["type"])
            arr.push(a["relevance"])
            arr.push(a["count"])
            entities[a["text"]]=arr
            sentiments[a["sentiment"]["type"]]= sentiments[a["sentiment"]["type"]] + 1

            #binding.pry
        end
      end

     end

     entities=entities.sort_by{|k,v| v[3].to_i }.reverse.to_h
     entities.each do |key,value|
       place.entities.create(:name => key, :type_t => value[0], :sentiment => value[1], :relevance => value[2], :count => value[3])
     end

     concepts.each do |concept|
       concept["concepts"].each do |c|
        typeHierarchy=""
        geo=""
        website=""

        name=c["text"]
        relevance=c["relevance"]
        if c.has_key?("geo")
          geo=c["geo"]
        end
        if c.has_key?("website")
          website=c["website"]
        end
        place.concepts.create(:name => name, :relevance => relevance , :geo => geo ,:website =>website)
       end
     end

    end

  end

end

desc "TODO"
task wikipedia: :environment do
  require 'wikipedia'
  data=Hash.new
  i=0
  places=Place.all
  places.each do |place|
  puts "#{place.name}"
  entities=place.entities.all
  entities.each do |entity|

    arr=Array.new
    page=Wikipedia.find(entity.name)
    if !page.raw_data["query"]["pages"].has_key?("-1")
      puts "#{entity.name}"
      binding.pry
      #place.get_places.create(:title =>page.title,:image_url => page.image_urls[0],:summary => page.summary)
      puts "#{i}"
      i=i+1
    end

    end
  end

end



end
