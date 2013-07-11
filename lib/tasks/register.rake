# -*- coding: utf-8 -*-
namespace :register do

  # CSVファイルからマスタ系テーブルにデータ登録する
  desc "Register master tables"
  task :master => :environment do

    require 'csv'
    CSV_PATH = "#{Rails.root}/lib/batches"

    count = 0
    puts " #{Time.now} ===== START ===== "
    begin
      ActiveRecord::Base.transaction do
        store(Area, 'area.csv') do |row|
          Area.new(row.to_hash.merge("polygon"=>nil)).save!
        end
        store(Agent, 'agent.csv')
        store(PredefinedPosition, 'predefined_position.csv')
        store(GatheringPosition, 'gathering_position.csv')
        store(Department, 'department.csv')
      end
    end
    puts " #{Time.now} =====  END  ===== "
  end

  # CSVファイル内容をDBにストアする
  # ※ブロック指定時はブロックに処理を提供する
  def store(klass, filename, options={}, &block)
    file = File.join(CSV_PATH, filename)
    if File.exists?(file)
      CSV.open(file, "r", {:headers => :first_row, :encoding => "utf-8"}) do |csv|
        klass.destroy_all
        csv.each do |row|
          if block_given?
            yield row
          else
            klass.new(row.to_hash).save!
          end
        end
      end
      puts " #{Time.now} #{file} -> #{klass.table_name}"
    end
  end

end
