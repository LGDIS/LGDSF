class Agent < ActiveRecord::Base
  attr_accessible :id, :name, :mail_address

  has_one :staff
end
