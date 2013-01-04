class Agent < ActiveRecord::Base
  attr_accessible :id, :name, :mail_address

  has_one :staff
  has_one :predefined_position
end
