# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  before_filter :init

  protect_from_forgery

  layout :layout_by_resource

  # 初期処理
  # ==== Args
  # ==== Return
  # ==== Raise
  def init
    # memcacheからマスタを取得
    # !!! 暫定
    @departments          = createDepartments(Rails.cache.read("department"))
    @areas                = createAreas(Rails.cache.read("area"))
    @predefined_positions = createPredefinedPositions(Rails.cache.read("predefined_position"))
    @gathering_positions  = Rails.cache.read("gathering_position")
  end

  # 部署データ作成処理
  # ==== Args
  # ==== Return
  # 部署データ
  # ==== Raise
  def createDepartments(hashs)
    data = []
    i = 0
    hashs.each_value do |value|
      data[i] = Department.new
      data[i].id = i + 1
      data[i].name = value["name"]
      data[i].remarks = value["remarks"]
      i += 1
    end
    return data
  end

  # 地区データ作成処理
  # ==== Args
  # ==== Return
  # 地区データ
  # ==== Raise
  def createAreas(hashs)
    data = []
    i = 0
    hashs.each_value do |value|
      data[i] = Area.new
      data[i].id = i + 1
      data[i].name = value["name"]
      data[i].remarks = value["remarks"]
      data[i].polygon = value["polygon"]
      i += 1
    end
    return data
  end

  # 所定の参集場所データ作成処理
  # ==== Args
  # ==== Return
  # 所定の参集場所データ
  # ==== Raise
  def createPredefinedPositions(hashs)
    data = []
    i = 0
    hashs.each_value do |value|
      data[i] = PredefinedPosition.new
      data[i].id = i + 1
      data[i].agent_id = value["agent_id"].to_i
      data[i].position_code = value["position_code"]
      i += 1
    end
    return data
  end

  # 参集場所データ作成処理
  # ==== Args
  # ==== Return
  # 参集場所データ
  # ==== Raise
  def createGatheringPositions(hashs)
    data = []
    i = 0
    hashs.each_value do |value|
      data[i] = GatheringPosition.new
      data[i].id = i + 1
      data[i].name = value["name"]
      data[i].area_dai_code = value["area_dai_code"]
      data[i].address_code = value["address_code"]
      data[i].address = value["address"]
      data[i].latitude = value["latitude"].to_f
      data[i].longitude = value["longitude"].to_f
      data[i].remarks = value["remarks"]
      i += 1
    end
    return data
  end

  protected
  def layout_by_resource
    if devise_controller? && !user_signed_in?
      "users"
    else
      "application"
    end
  end

end
