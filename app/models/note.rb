class Note < ActiveRecord::Base
  attr_accessible :note, :staff_id
  
  belongs_to :staff
  
  # 対象の職員の災害番号取得処理
  # ==== Args
  # ==== Return
  # 職員の災害番号
  # ==== Raise
  def disaster_code
    self.staff.disaster_code
  end

  # 対象の職員の名前取得処理
  # ==== Args
  # ==== Return
  # 職員の名前
  # ==== Raise
  def name
    self.staff.name
  end

  validates :note,
              :length => {:maximum => 40}
  
end
