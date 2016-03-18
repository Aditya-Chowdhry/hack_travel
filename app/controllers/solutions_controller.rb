class SolutionsController < ApplicationController
 require 'faker'
  def create
  	@solution = Solution.new(solution_params)
  	Faker::Config.locale = 'en-IND'
  	@solution.update(:name => Faker::Name.name)
    respond_to do |format|
      if @solution.save
        format.html { redirect_to :back, notice: 'Solution was successfully created.' }
        format.json { render :show, status: :created, location: @solution }
      else
        format.html { render :new }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end

  end

  def new
  	 @solution = Solution.new
  end

  private
   
    def solution_params
      params.require(:solution).permit(:title, :type_, :body, :entity,:tourist_place_id)
    end
end
