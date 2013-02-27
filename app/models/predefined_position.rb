# -*- coding:utf-8 -*-
class PredefinedPosition
  include ActiveModel::AttributeMethods

  attribute_method_affix :prefix => 'clear_', :suffix => '!'
  define_attribute_methods [:id, :agent_id, :position_code]

  attr_accessor :id, :agent_id, :position_code

  # 属性の初期化処理
  # ==== Args
  # ==== Return
  # ==== Raise
  def clear_attribute!(attr)
    send("#{attr}=", nil)
  end

  #has_one    :gathering_position
  #belongs_to :agent
  #belongs_to :staff, :foreign_key => "agent_id"
end
