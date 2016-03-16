class TouristPlace < ActiveRecord::Base
  belongs_to :place
  has_many :reviews
end
