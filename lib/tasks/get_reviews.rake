namespace :get_reviews do
  desc "TODO"
  task fetch_data: :environment do
    require 'httparty'
    require 'nokogiri'
    require 'json'
    require 'pry'
    require 'csv'
    require 'date'
    
    city_page =  Nokogiri::HTML(open("/home/aditya/places.html"))

    cities = city_page.css("div.popularCities")[0].css("a")
    places_array = Array.new
    i = 0
    cities.each do |city|
      places_array.push(city["href"])
      i = i + 1
      if i == 20
        break
      end
    end
    places_array.each do |url|
      url = url.split("-")
      puts url
      page = HTTParty.get("https://www.tripadvisor.in/Attractions-#{url[1]}-Activities-#{url[2]}.html")
      places_page = Nokogiri::HTML(page)

      #This array will contain links of top 15 places to visit
      places_link = Array.new 
      places = places_page.css("#FILTERED_LIST").css("div.photo_booking")
      j = 0
      places.each do |place|
        if j < 15
          j = j + 1
          
        end
        #Pry.start(binding)
          
        link = place.css("a")[0]["href"]
        if link.include? "Attraction_Review"
          places_link.push(link)
        end

      end

      #Pry.start(binding)
      places_link.each do |place|

        place_name = place.split("-")
        puts place_name
        puts "place_name :"+ place_name[1]
        
        number_of_reviews = 3
        review_ids = Array.new

        number_of_reviews.times do |i|
          if i == 0
            page = HTTParty.get("https://www.tripadvisor.in#{place_name[0]}-#{place_name[1]}-#{place_name[2]}-Reviews-#{place_name[3]}-#{place_name[4]}")
            
          else
            page = HTTParty.get("https://www.tripadvisor.in#{place_name[0]}-#{place_name[1]}-#{place_name[2]}-Reviews-or#{i}0-#{place_name[3]}-#{place_name[4]}#REVIEWS")
          end
          
          review_page = Nokogiri::HTML(page)

          reviews = review_page.css("#REVIEWS").css("div.reviewSelector")

          reviews.each do |x|
            review_ids.push(x["id"].split("_")[1])

          end
          puts "Working on page #{i}"
          #break
        end

        
        review = ""
        
        name = url[2].split("_")
        if(name[0] == "Bengaluru")
          name[0] = "Bangalore"
        end
        place = Place.find_by(:name => name[0])
        if(place.nil?)
          #Pry.start(binding)
          state = State.find_by(:name => name[1])
          state.places.create(:name => name[0])    
        end
        place = Place.find_by(:name => name[0])
       
        #Pry.start(binding)
        
        tourist_place = place_name[4].split("_").join(" ")
        #Pry.start(binding)
        
        place.tourist_places.create(:name => tourist_place)
        tourist_place = TouristPlace.find_by(:name => tourist_place)
        review_ids.each do |r|
          page = HTTParty.get("https://www.tripadvisor.in/ShowUserReviews-#{place_name[1]}-#{place_name[2]}-r#{r}-#{place_name[3]}-#{place_name[4]}#REVIEWS")
          puts "https://www.tripadvisor.in/ShowUserReviews-#{place_name[1]}-#{place_name[2]}-r#{r}-#{place_name[3]}-#{place_name[4]}#REVIEWS"
          review_page = Nokogiri::HTML(page)
          review = review_page.css("#review_#{r}")
          review_date = review.css("span.ratingDate")[0]["content"]
          review_body = review.css("p").text.strip
          puts review_date
          puts review_body[0..10]
          review_date = Date.parse(review_date)
          #Pry.start(binding)
          tourist_place.reviews.create(:review_date => review_date, :review_body => review_body)
        end
      end
    end


  end

  task fetch_data2: :environment do
    require 'httparty'
    require 'nokogiri'
    require 'json'
    require 'pry'
    require 'csv'
    require 'date'
    
    city_page =  Nokogiri::HTML(open("/home/aditya/places1.html"))

    cities = city_page.css("div.popularCities")[0].css("a")
    places_array = Array.new
    i = 0
    cities.each do |city|
      places_array.push(city["href"])
      i = i + 1
      if i == 20
        break
      end
    end
    places_array.each do |url|
      url = url.split("-")
      puts url
      page = HTTParty.get("https://www.tripadvisor.in/Attractions-#{url[1]}-Activities-#{url[2]}.html")
      places_page = Nokogiri::HTML(page)

      #This array will contain links of top 15 places to visit
      places_link = Array.new 
      places = places_page.css("#FILTERED_LIST").css("div.photo_booking")
      j = 0
      places.each do |place|
        if j == 9
          break
        end
        #Pry.start(binding)
        j = j + 1
        link = place.css("a")[0]["href"]
        if link.include? "Attraction_Review"
          places_link.push(link)
        end

      end

      #Pry.start(binding)
      places_link.each do |place|

        place_name = place.split("-")
        puts place_name
        puts "place_name :"+ place_name[1]
        
        number_of_reviews = 3
        review_ids = Array.new

        number_of_reviews.times do |i|
          if i == 0
            page = HTTParty.get("https://www.tripadvisor.in#{place_name[0]}-#{place_name[1]}-#{place_name[2]}-Reviews-#{place_name[3]}-#{place_name[4]}")
            
          else
            page = HTTParty.get("https://www.tripadvisor.in#{place_name[0]}-#{place_name[1]}-#{place_name[2]}-Reviews-or#{i}0-#{place_name[3]}-#{place_name[4]}#REVIEWS")
          end
          
          review_page = Nokogiri::HTML(page)

          reviews = review_page.css("#REVIEWS").css("div.reviewSelector")

          reviews.each do |x|
            review_ids.push(x["id"].split("_")[1])

          end
          puts "Working on page #{i}"
          #break
        end

        
        review = ""
        
        name = url[2].split("_")
        
        place = Place.find_by(:name => name[0])
        if(place.nil?)
          #Pry.start(binding)
          state = State.find_by(:name => name[1])
          state.places.create(:name => name[0])    
        end
        place = Place.find_by(:name => name[0])
       
        #Pry.start(binding)
        
        tourist_place = place_name[4].split("_").join(" ")
        #Pry.start(binding)
        
        place.tourist_places.create(:name => tourist_place)
        tourist_place = TouristPlace.find_by(:name => tourist_place)
        review_ids.each do |r|
          page = HTTParty.get("https://www.tripadvisor.in/ShowUserReviews-#{place_name[1]}-#{place_name[2]}-r#{r}-#{place_name[3]}-#{place_name[4]}#REVIEWS")
          puts "https://www.tripadvisor.in/ShowUserReviews-#{place_name[1]}-#{place_name[2]}-r#{r}-#{place_name[3]}-#{place_name[4]}#REVIEWS"
          review_page = Nokogiri::HTML(page)
          review = review_page.css("#review_#{r}")
          review_date = review.css("span.ratingDate")[0]["content"]
          review_body = review.css("p").text.strip
          puts review_date
          puts review_body[0..10]
          review_date = Date.parse(review_date)
          #Pry.start(binding)
          tourist_place.reviews.create(:review_date => review_date, :review_body => review_body)
        end
      end
    end


  end

  task fetch_data3: :environment do
    require 'httparty'
    require 'nokogiri'
    require 'json'
    require 'pry'
    require 'csv'
    require 'date'
    
    city_page =  Nokogiri::HTML(open("/home/aditya/places2.html"))

    cities = city_page.css("div.popularCities")[0].css("a")
    places_array = Array.new
    i = 0
    cities.each do |city|
      places_array.push(city["href"])
      i = i + 1
      if i == 20
        break
      end
    end
    places_array.each do |url|
      url = url.split("-")
      puts url
      page = HTTParty.get("https://www.tripadvisor.in/Attractions-#{url[1]}-Activities-#{url[2]}.html")
      places_page = Nokogiri::HTML(page)

      #This array will contain links of top 15 places to visit
      places_link = Array.new 
      places = places_page.css("#FILTERED_LIST").css("div.photo_booking")
      j = 0
      places.each do |place|
        if j == 21
          j = j + 1
        end
        #Pry.start(binding)
          
        link = place.css("a")[0]["href"]
        if link.include? "Attraction_Review"
          places_link.push(link)
        end

      end

      #Pry.start(binding)
      places_link.each do |place|

        place_name = place.split("-")
        puts place_name
        puts "place_name :"+ place_name[1]
        
        number_of_reviews = 3
        review_ids = Array.new

        number_of_reviews.times do |i|
          if i == 0
            page = HTTParty.get("https://www.tripadvisor.in#{place_name[0]}-#{place_name[1]}-#{place_name[2]}-Reviews-#{place_name[3]}-#{place_name[4]}")
            
          else
            page = HTTParty.get("https://www.tripadvisor.in#{place_name[0]}-#{place_name[1]}-#{place_name[2]}-Reviews-or#{i}0-#{place_name[3]}-#{place_name[4]}#REVIEWS")
          end
          
          review_page = Nokogiri::HTML(page)

          reviews = review_page.css("#REVIEWS").css("div.reviewSelector")

          reviews.each do |x|
            review_ids.push(x["id"].split("_")[1])

          end
          puts "Working on page #{i}"
          #break
        end

        
        review = ""
        
        name = url[2].split("_")

        place = Place.find_by(:name => name[0])
        if(place.nil?)
          #Pry.start(binding)
          state = State.find_by(:name => name[1])
          state.places.create(:name => name[0])    
        end
        place = Place.find_by(:name => name[0])
       
        #Pry.start(binding)
        
        tourist_place = place_name[4].split("_").join(" ")
        #Pry.start(binding)
        
        place.tourist_places.create(:name => tourist_place)
        tourist_place = TouristPlace.find_by(:name => tourist_place)
        review_ids.each do |r|
          page = HTTParty.get("https://www.tripadvisor.in/ShowUserReviews-#{place_name[1]}-#{place_name[2]}-r#{r}-#{place_name[3]}-#{place_name[4]}#REVIEWS")
          puts "https://www.tripadvisor.in/ShowUserReviews-#{place_name[1]}-#{place_name[2]}-r#{r}-#{place_name[3]}-#{place_name[4]}#REVIEWS"
          review_page = Nokogiri::HTML(page)
          review = review_page.css("#review_#{r}")
          review_date = review.css("span.ratingDate")[0]["content"]
          review_body = review.css("p").text.strip
          puts review_date
          puts review_body[0..10]
          review_date = Date.parse(review_date)
          #Pry.start(binding)
          tourist_place.reviews.create(:review_date => review_date, :review_body => review_body)
        end
      end
    end


  end

end
