# -*- coding:utf-8 -*-
# 職員情報削除バッチ
# ==== バッチの実行コマンド
# rails runner Batches::StaffsDestroy.execute
# ==== options
# 実行環境の指定 :: -e production

class Batches::StaffsDestroy
  def self.execute
    puts " #{Time.now.to_s} ===== #{self.name} START ===== "

    Staff.destroy_all(["updated_at < ?", 1.year.ago])

    puts " #{Time.now.to_s} ===== #{self.name} END  ===== "
  end
end
