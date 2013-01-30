class ApplicationController < ActionController::Base
  before_filter :init

  protect_from_forgery

  # 初期処理
  # ==== Args
  # ==== Return
  # ==== Raise
  def init
    # memcacheからマスタを取得
    # !!! 暫定
    @gathering_positions  = Rails.cache.read("gathering_position")
    @predefined_positions = Rails.cache.read("predefined_position")
  end
end
