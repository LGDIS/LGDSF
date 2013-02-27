# -*- coding:utf-8 -*-
class Area
  include ActiveModel::AttributeMethods

  attribute_method_affix :prefix => 'clear_', :suffix => '!'
  define_attribute_methods [:id, :name, :remarks, :polygon]

  attr_accessor :id, :name, :remarks, :polygon

  # 属性の初期化処理
  # ==== Args
  # ==== Return
  # ==== Raise  
  def clear_attribute!(attr)
    send("#{attr}=", nil)
  end
end
