class Staff < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :agent_id,
                  :reason, :name, :status, :destination, :mail_id

  has_one :predefined_position, :foreign_key => "agent_id"
  belongs_to :agent

  def mail_address
    self.agent.mail_address
  end
end
