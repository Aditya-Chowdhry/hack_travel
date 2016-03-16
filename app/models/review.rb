class Review < ActiveRecord::Base
  belongs_to :tourist_place
  has_one :analyse_review
end
