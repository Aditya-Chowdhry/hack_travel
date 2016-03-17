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
	   	if i < 6259
	   		next
	   	end
	   	puts review.review_date
		entity_url = 'http://access.alchemyapi.com/calls/text/TextGetRankedNamedEntities?apikey=f3b7f0e3ab62058d6f52155b75817d0cc52b2763&text=' + review.review_body + '&outputMode=json&sentiment=1'
	  	#f3b7f0e3ab62058d6f52155b75817d0cc52b2763
	  	#9e214fad5da4294127553b1271b3f0f175f7ca05
	  	#04cf57d7207ef4b157b493aebc0c43895d68b004
	  	#f95379874f5e221e4f909253683790593d8566bf
	  	#8a0068c37c2d490f0da49f6fff1489df8f0c13e0
	  	#1fc152878a2912eeb726da705246b4f006c26984
	  	#dd7f5c0e953e1da3fea91b06ddf1d4cf115e593e
	  	#62295afe46ae29755d1e7859ff03e5bd13ac60c7
	  	#71b06e8d42d20768a0a98999986f7235acca4998
	  	#b98fbe6a3ac52f2370201c372fdbbb6a9296f7e7
	  	
	  	entity_url = URI.escape(entity_url)

	  	entity_response = HTTParty.post(entity_url,
	         :headers => {"Content-Type" => "application/x-www-form-urlencoded"}
	        )
	  	#Pry.start(binding)
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
