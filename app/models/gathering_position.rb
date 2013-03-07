# -*- coding:utf-8 -*-
class GatheringPosition < ActiveRecord::Base
  attr_accessible :position_code, :name, :area_dai_code, :address_code, :address, :latitude, :longitude, :remarks

  # 参集場所ハッシュ取得処理
  # ==== Args
  # ==== Return
  # 参集場所ハッシュオブジェクト
  # ==== Raise
  def self.hash_for_table
    result = {}
    self.order(:position_code).each do |item|
      result[item.position_code] ||= {}
      result[item.position_code] = item
    end
    return result
  end
end
