class Agent < ActiveRecord::Base
  attr_accessible :id, :name, :mail_address

  has_one :staff

  validates :name,
              :length => {:maximum => 64}
  validates :mail_address,
              :length => {:maximum => 256}
end
