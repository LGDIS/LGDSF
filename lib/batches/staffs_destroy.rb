# -*- coding:utf-8 -*-
# 避難者情報削除バッチ
# ==== バッチの実行コマンド
# rails runner Batches::StaffsDestroy.execute
# ==== options
# 実行環境の指定 :: -e production

class Batches::StaffsDestroy
  def self.execute
    Rails.logger.info(" #{Time.now.to_s} ===== #{self.name} START ===== ")

    Staff.destroy_all(["updated_at < ?", 1.year.ago])

    Rails.logger.info(" #{Time.now.to_s} ===== #{self.name} END  ===== ")
  end
end
