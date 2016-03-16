namespace :analyse do
  desc "TODO"
  task alchemy: :environment do
  	reviews = Review.all
  	i = 0
  	reviews.each do |review|
	  	# t.string   "entities"
	   #  t.string   "sentiments"
	   #  t.string   "counts"
	   #  t.string   "relevances"
	   #  t.string   "types"
	   #  t.integer  "review_id"
	   	
	   	puts "#{i+1}"
	   	i = i + 1
	   	if i < 500
	   		next
	   	end
	   	puts review.review_date
		entity_url = 'http://access.alchemyapi.com/calls/text/TextGetRankedNamedEntities?apikey=f3b7f0e3ab62058d6f52155b75817d0cc52b2763&text=' + review.review_body + '&outputMode=json&sentiment=1'
	  	#f3b7f0e3ab62058d6f52155b75817d0cc52b2763
	  	#9e214fad5da4294127553b1271b3f0f175f7ca05
	  	entity_url = URI.escape(entity_url)

	  	entity_response = HTTParty.post(entity_url,
	         :headers => {"Content-Type" => "application/x-www-form-urlencoded"}
	        )

	  	entities = ""
	  	sentiments = ""
	  	counts = ""
	  	relevances = ""
	  	types = ""
	  	scores = ""
	  	entity_response["entities"].each do |entity|
	  		entities += entity["text"] + ","
	  		sentiments += entity["sentiment"]["type"] + ","
	  		scores += entity["sentiment"]["score"].to_s + ","
	  		counts += entity["count"].to_s + ","
	  		relevances += entity["relevance"].to_s + ","	
	  		types += entity["type"] + ","
	  	end
	  	puts entity_response["entities"].size
	  	#Pry.start(binding)
	  	AnalyseReview.create(:review_id => review.id, :entities => entities, :sentiments => sentiments, :scores => scores, :counts => counts, :types => types, :relevances => relevances)
		
	end
  end
end
