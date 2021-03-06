# -*- coding:utf-8 -*-
class Staff < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :agent_id,
                  :reason, :name, :status, :destination_code, :disaster_code

  belongs_to :agent

  validates :name,
              :length => {:maximum => 64}
  validates :destination_code,
              :length => {:maximum => 20}
  validates :disaster_code,
              :length => {:maximum => 20}

  # 対象の職員のメールアドレス取得処理
  # ==== Args
  # ==== Return
  # 職員のメールアドレス
  # ==== Raise
  def mail_address
    self.agent.mail_address
  end

  # 対象の職員の部署取得処理
  # ==== Args
  # ==== Return
  # 職員の部署
  # ==== Raise
  def department
    self.agent.department
  end
end
