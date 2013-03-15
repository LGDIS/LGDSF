#!/bin/bash
#1年以上更新されていない職員情報を削除する

# Rails.rootに遷移する
cd /path/to/deploy

rails runner Batches::StaffsDestroy.execute -e production >> log/staffs_destroy.log 2>&1

exit 0
