class Shelter < ActiveRecord::Base
  attr_accessible :name, :latitude, :longitude

  belongs_to :predefined_position
end
