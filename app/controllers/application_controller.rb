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
    @areas                = Area.all
    @departments          = Department.all
    @predefined_positions = PredefinedPosition.order("CAST( agent_id AS integer)")
    @gathering_positions  = GatheringPosition.hash_for_table
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
