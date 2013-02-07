﻿# -*- coding:utf-8 -*-
class Staff < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :agent_id,
                  :reason, :name, :status, :destination_code, :disaster_code

  belongs_to :agent

  # 対象の職員のメールアドレス取得処理
  # ==== Args
  # ==== Return
  # 職員のメールアドレス
  # ==== Raise
  def mail_address
    self.agent.mail_address
  end
end
