# マスターデータの投入

初期データ投入後（db:seed)、下記のコマンドでマスターデータを投入する。

## １．各種マスタデータのcsvを作成する

各種マスタを作成する（lib/batchesにある各csvのexample参照）。

* area.csv : 地区マスタ。参集場所の区分に使用する。
* department.csv : 部署マスタ。
* gathering_position.csv : 参集場所マスタ。
* predefined_position.csv : 所定の参集場所マスタ。職員毎の所定の参集場所を設定。

上記のファイルをlib/bathchesに配置する。

## ２．マスタデータを投入する

下記のコマンドを実行する。

	bundle exec rake register:master RAILS_ENV=production

