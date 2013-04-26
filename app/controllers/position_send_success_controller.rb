# -*- coding: utf-8 -*-
class PositionSendSuccessController < ApplicationController

  layout :layout_selector
  # 参集場所報告メッセージ画面
  # "送信しました。"と画面上部に表示
  # ==== Args
  # ==== Return
  # ==== Raise
  def index
    # モバイルの場合は、モバイル用のviewに切替える
    if request.mobile?
      render "position_send_success_mobile"
    else
      render "position_send_success"
    end
  end

  # レイアウトの選択処理
  # 各画面で使用するレイアウトを決定する
  # ==== Args
  # ==== Return
  # レイアウト名
  # ==== Raise
  def layout_selector
    request.mobile? ? 'lgdsf_mobile' : 'lgdsf_smartphone' # Feature/Smart-Phone
  end
end
