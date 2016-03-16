class Place < ActiveRecord::Base
  belongs_to :state
  has_many :tourist_places
  has_many :get_places
  has_many :entities
  has_many :concepts
  has_many :reviews
end
