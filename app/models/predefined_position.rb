class PredefinedPosition < ActiveRecord::Base
  attr_accessible :agent_id, :shelter_id

  has_one    :shelter
  belongs_to :agent
  belongs_to :staff, :foreign_key => "agent_id"
end
