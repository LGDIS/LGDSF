class Agent < ActiveRecord::Base
  attr_accessible :name, :mail_address, :department, :path

  has_many :staff

  validates :name,
              :length => {:maximum => 64}
  validates :mail_address,
              :length => {:maximum => 256}
  validates :department,
              :length => {:maximum => 64}
  validates :path,
              :length => {:maximum => 64}
end