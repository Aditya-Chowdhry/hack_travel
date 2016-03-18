class ReviewsController < ApplicationController
  # GET /reviews
  # GET /reviews.json
  require 'faker'
  Faker::Config.locale = :en
  def index
    @reviews = Review.all
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
    @solution = Solution.new
  	@entity_name = params[:name]

    @solutions = Solution.where(:entity => @entity_name)
    @place_id = params[:id]
    
    place = TouristPlace.find(@place_id)

    reviews = place.reviews
    @targeted_reviews = Array.new
    @names = Array.new
    reviews.each do |review|
      analysed_review = review.analyse_review
      if analysed_review
        entities = analysed_review.entities.split(",")
        entities.each do |entity|
          if(entity == @entity_name)
            text = review.review_body
            index = text.index(entity)
            
            text = text[0..index-1] + "<span style=\"background-color:yellow;\">" + entity + "</span>" + text[index + entity.size..text.size]
            @targeted_reviews.push(text)
            @names.push(Faker::Name.name)
            break
          end
        end
      end
    end
  	#Pry.start(binding)
  	#place = TouristPlace.find(params[:id])
  	@reviews = place.reviews

  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)

    respond_to do |format|
      if @review.save
        format.html { redirect_to @review, notice: 'Review was successfully created.' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end
    #  t.date     "review_date"
    # t.text     "review_body"
    # t.integer  "tourist_place_id"
    # t.datetime "created_at",       null: false
    # t.datetime "updated_at",       null: false
    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:tourist_place_id, :review_date, :review_body)
    end
end
